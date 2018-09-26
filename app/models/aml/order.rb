module AML
  class Order < ApplicationRecord
    extend Enumerize
    include Workflow
    include Archivable

    scope :ordered, -> { order 'id desc' }

    belongs_to :aml_client, class_name: 'AML::Client', foreign_key: 'client_id', inverse_of: :aml_orders, dependent: :destroy
    belongs_to :aml_operator, class_name: 'AML::Operator', foreign_key: 'operator_id', optional: true, inverse_of: :aml_orders
    belongs_to :aml_status, class_name: 'AML::Status'

    has_many :aml_order_documents, class_name: 'AML::OrderDocument', dependent: :destroy

    before_validation :set_default_aml_status, unless: :aml_status

    workflow do
      # Находится на стадии загрузки пользователем
      #
      state :none do
        event :done, transitions_to: :pending, if: :all_documents_loaded?
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
        event :reject, transitions_to: :rejected
      end

      state :rejected do
        event :accept, transitions_to: :accepted
      end
    end

    after_create :create_documents!

    def reject(reject_reason:)
      halt! 'Причина должна быть указана' unless reject_reason.present?
      update reject_reason: reject_reason
    end

    def is_locked?
      accepted? || processing? || accepted? || rejected?
    end

    def complete?
      aml_order_documents.select(:complete?).count == aml_order_documents.count
    end

    def get_order_document_by_kind(aml_document_kind)
      with_lock do
        aml_order_documents
          .create_with(order: self)
          .find_or_create_by!(aml_document_kind: aml_document_kind)
      end
    end

    def all_documents_loaded?
      aml_order_documents.map(&:workflow_state).uniq == ['loaded']
    end

    # Создает и до-создает набор документов для
    # заявки. Выполняется при содании заявки и при добавлении нового вида документов
    #
    def create_documents!
      DocumentKind.alive.each do |aml_document_kind|
        aml_order_documents.find_or_create_by! aml_order: self, aml_document_kind: aml_document_kind
      end
    end

    def set_default_aml_status
      self.aml_status ||= AML.default_status
    end
  end
end
