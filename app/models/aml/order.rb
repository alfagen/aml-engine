module AML
  class Order < ApplicationRecord
    extend Enumerize
    include Workflow
    include Authority::Abilities

    self.table_name = 'aml_orders'

    enumerize :workflow_state, in: %w[none pending processing accepted rejected], scope: true

    scope :ordered, -> { order 'id desc' }

    belongs_to :client, class_name: 'AML::Client', foreign_key: 'client_id', inverse_of: :orders
    belongs_to :user, class_name: 'AML::User', foreign_key: 'user_id', optional: true, inverse_of: :orders
    has_many :client_documents, class_name: 'AML::ClientDocument', dependent: :destroy

    validates :first_name, presence: true
    validates :surname, presence: true
    validates :patronymic, presence: true
    validates :birth_date, presence: true

    workflow do
      state :none do
        event :load, transitions_to: :pending
      end

      state :pending do
        event :process, transitions_to: :processing
      end

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

    def complete?
      client_documents.count == AML::DocumentKind.count
    end

    def missing_documents
      AML::DocumentKind.where.not(id: client_documents.pluck(:document_kind_id))
    end
  end
end
