module AML
  class Order < ApplicationRecord
    extend Enumerize
    include Workflow
    include Archivable

    ATTRIBUTES_TO_CLONE = %w(first_name surname patronymic birth_date).freeze

    scope :open, -> { where workflow_state: %w(pending processing) }

    belongs_to :client, class_name: 'AML::Client', foreign_key: :client_id, inverse_of: :orders, dependent: :destroy
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: :operator_id, optional: true, inverse_of: :orders
    belongs_to :aml_status, class_name: 'AML::Status'
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', optional: true

    has_many :order_documents, class_name: 'AML::OrderDocument', dependent: :destroy
    has_many :required_document_kinds, through: :aml_status, source: :document_kinds
    has_many :order_checks, class_name: 'AML::OrderCheck', dependent: :destroy, inverse_of: :aml_order, foreign_key: :aml_order_id

    has_many :aml_check_lists, class_name: 'AML::CheckList', through: :order_checks

    before_validation :set_default_aml_status, unless: :aml_status

    validates :first_name, presence: true, if: :require_fields?
    validates :surname, presence: true, if: :require_fields?
    validates :birth_date, presence: true, if: :require_fields?

    ransacker :id do
      Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
    end

    workflow do
      # Находится на стадии загрузки пользователем
      # TODO переименовать none в draft
      state :none do
        event :done, transitions_to: :pending, if: :allow_done?

        # Когда создается новая заявка, старая переходит в статус cancel
        event :cancel, transitions_to: :canceled
      end

      # Пользователь загрузил, ждет когда оператор начнет обрабатывать
      state :pending do
        on_entry do
          create_checks
          notify :on_pending_notification
        end
        event :start, transitions_to: :processing
        event :cancel, transitions_to: :canceled
      end

       # Оператор начал обрабатывать
      state :processing do
        event :accept, transitions_to: :accepted, if: :allow_accept?
        event :reject, transitions_to: :rejected
        event :cancel, transitions_to: :pending
      end

      state :accepted do
        # TODO сомнительно что можно так делать
        event :reject, transitions_to: :rejected
        on_entry do
          notify :on_accept_notification
        end
      end

      # Отклонена оператором
      state :rejected do
        on_entry do
          notify :on_reject_notification
        end
      end

      # Отменена пользователем (или автоматом при создании новой)
      state :canceled
    end

    before_create :copy_fields_from_current_order!
    after_create :create_and_clone_documents!
    after_create :set_current_order!
    after_create :cancel_previous_orders!

    def reject(reject_reason:, details: nil)
      halt! 'Причина должна быть указана' unless reject_reason.is_a? AML::RejectReason
      update aml_reject_reason: reject_reason, reject_reason_details: details
      touch :operated_at
    end

    def notification_locale
      client.notification_locale || I18n.default_locale
    end

    def notify(notification_key)
      notification = aml_status.send notification_key
      unless notification
        AML::NotificationMailer.logger.warn "No #{notification_key} notification for status #{aml_status}"
        return
      end

      notification_template = notification.
        aml_notification_templates.
        find_by(locale: notification_locale)

      unless notification_template.present? && notification_template.template_id.present?
        AML::NotificationMailer.logger.warn "No template_id for #{notification} and #{locale}"
        return
      end

      client.notify notification_template.template_id,
        first_name: (first_name.presence || client.first_name),
        reject_reason_title: aml_reject_reason.try(:title),
        reject_reason_details: reject_reason_details.presence
    end

    def accept
      client.update attributes_to_clone.merge current_order: self, aml_accepted_order: self, aml_status: aml_status
      touch :operated_at
    end

    def is_locked?
      !none?
    end

    def is_owner?(operator)
      self.operator == operator
    end

    def complete?
      order_documents.select(:complete?).count == order_documents.count
    end

    def start(operator:)
      update operator: operator
    end

    def cancel
      update operator: nil
      touch :operated_at
    end

    def done
      halt! 'Личная анкета не до конца заполнена' unless fields_present?
      touch :pending_at
    end

    def client_name
      ["##{client_id}", first_name, surname, patronymic].compact.join ' '
    end

    def allow_done?
      all_documents_loaded? && fields_present?
    end

    def fields_present?
      first_name.present? && surname.present? && birth_date.present?
    end

    def require_fields?
      pending? || processing? || accepted?
    end

    def all_documents_loaded?
      order_documents.any? && order_documents.all? { |o| o.loaded? }
    end

    def allow_accept?
      all_documents_accepted? && client.risk_category.present? && all_checks_accepted?
    end

    def all_documents_accepted?
      order_documents.any? && order_documents.all? { |o| o.accepted? }
    end

    def all_checks_accepted?
      order_checks.all? { |check| check.accepted? }
    end

    protected

    def attributes_to_clone
      @attributes_to_clone ||= attributes.slice(*ATTRIBUTES_TO_CLONE)
    end

    private

    def create_checks
      AML::CheckList.alive.ordered.each do |c|
        order_checks.create! aml_check_list: c
      end
    end

    def copy_fields_from_current_order!
      return unless attributes_to_clone.compact.empty?
      return unless client.current_order.present?
      return unless client.current_order.attributes_to_clone.compact.any?

      assign_attributes client.current_order.attributes_to_clone
    end

    # Создает и до-создает набор документов для
    # заявки. Выполняется при содании заявки и при добавлении нового вида документов
    #
    def create_and_clone_documents!
      aml_status.aml_document_groups.find_each do |g|
        g.document_kinds.alive.ordered.each do |document_kind|
          image = client.current_order.present? ?
            client.current_order.order_documents.loaded_and_available.where(document_kind: document_kind).take&.image :
            nil

          order_documents.
            create_with(image: image).
            find_or_create_by! order: self, document_kind: document_kind
        end
      end
    end

    def set_current_order!
      client.update! current_order: self
    end

    def cancel_previous_orders!
      client.orders.where(workflow_state: [:none, :pending]).where.not(id: id).find_each do |o|
        o.cancel!
      end
    end

    def set_default_aml_status
      self.aml_status ||= ::AML.default_status
    end
  end
end
