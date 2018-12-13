module AML
  class Order < ApplicationRecord
    extend Enumerize
    include Workflow
    include CommonMethods
    include OrdersWorkflow
    include Archivable
    include Authority::Abilities
    include OrderCardHoldingSupport

    ATTRIBUTES_TO_CLONE = %w(first_name surname patronymic birth_date).freeze

    scope :open, -> { where workflow_state: %w(pending processing) }

    belongs_to :client, class_name: 'AML::Client', foreign_key: :client_id, inverse_of: :orders, dependent: :destroy
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: :operator_id, optional: true, inverse_of: :orders
    belongs_to :aml_status, class_name: 'AML::Status'
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', optional: true
    belongs_to :cloned_order, class_name: 'AML::Order', optional: true

    has_one :aml_client_info, through: :client

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

    before_create :copy_fields_from_current_order!
    after_create :create_and_clone_documents!
    after_create :set_current_order!
    after_create :cancel_previous_orders!

    def accept
      client.update attributes_to_clone.merge current_order: self, aml_accepted_order: self, aml_status: aml_status
      touch :operated_at
    end

    def is_locked?
      !none?
    end

    def complete?
      order_documents.select(:complete?).count == order_documents.count
    end

    def done
      halt! 'Личная анкета не до конца заполнена' unless fields_present?
      touch :pending_at
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
      self.cloned_order = client.current_order

      return unless cloned_order.attributes_to_clone.compact.any?

      assign_attributes cloned_order.attributes_to_clone
    end

    # Создает и до-создает набор документов для
    # заявки. Выполняется при содании заявки и при добавлении нового вида документов
    #
    def create_and_clone_documents!
      aml_status.aml_document_groups.find_each do |g|
        g.document_kinds.alive.ordered.each do |document_kind|
          image = cloned_order.present? ?
            cloned_order.order_documents.loaded_and_available.where(document_kind: document_kind).take&.image :
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
