module AML
  class Order < ApplicationRecord
    extend Enumerize
    include Workflow
    include Archivable

    scope :ordered, -> { order 'id desc' }

    belongs_to :client, class_name: 'AML::Client', foreign_key: 'client_id', inverse_of: :orders, dependent: :destroy
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: 'operator_id', optional: true, inverse_of: :orders
    belongs_to :aml_status, class_name: 'AML::Status'

    has_many :order_documents, class_name: 'AML::OrderDocument', dependent: :destroy

    before_validation :set_default_aml_status, unless: :aml_status

    validates :first_name, presence: true, if: :require_fields?
    validates :surname, presence: true, if: :require_fields?
    validates :birth_date, presence: true, if: :require_fields?

    workflow do
      # Находится на стадии загрузки пользователем
      #
      state :none do
        event :done, transitions_to: :pending, if: :allow_done?
      end

      # Пользователь загрузил, ждет когда оператор начнет обрабатывать
      state :pending do
        event :process, transitions_to: :processing
      end

       # Оператор начал обрабатывать
      state :processing do
        event :accept, transitions_to: :accepted
        event :reject, transitions_to: :rejected
        event :stop, transitions_to: :pending
      end

      state :accepted do
        # TODO сомнительно что можно так делать
        event :reject, transitions_to: :rejected
      end

      state :rejected do
        event :accept, transitions_to: :accepted
      end
    end

    after_create :create_documents!
    after_create :set_current_order!

    def reject(reject_reason:)
      halt! 'Причина должна быть указана' unless reject_reason.present?
      update reject_reason: reject_reason
    end

    def accept
      halt! 'Все документы должны быть приняты' unless all_documents_accepted?
      client.update current_order: self, aml_status: aml_status
    end

    def is_locked?
      processing? || accepted? || rejected?
    end

    def complete?
      order_documents.select(:complete?).count == order_documents.count
    end

    def done
      halt! 'Личная анкета не до конца заполнена' unless first_name.present? && surname.present? && birth_date.present?
    end

    def get_order_document_by_kind(document_kind)
      with_lock do
        order_documents
          .create_with(order: self)
          .find_or_create_by!(document_kind: document_kind)
      end
    end

    def allow_done?
      all_documents_loaded?
    end

    def require_fields?
      pending? || processing? || accepted?
    end

    def all_documents_loaded?
      order_documents.map(&:workflow_state).uniq == ['loaded']
    end

    def all_documents_accepted?
      order_documents.map(&:workflow_state).uniq == ['accepted']
    end

    # Создает и до-создает набор документов для
    # заявки. Выполняется при содании заявки и при добавлении нового вида документов
    #
    def create_documents!
      aml_status.aml_document_groups.find_each do |g|
        g.document_kinds.alive.ordered.each do  |document_kind|
          order_documents.find_or_create_by! order: self, document_kind: document_kind
        end
      end
    end

    def set_current_order!
      client.update! current_order: self
    end

    def set_default_aml_status
      self.aml_status ||= ::AML.default_status
    end
  end
end
