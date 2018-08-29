# frozen_string_literal: true

module AML
  class ClientDocument < ApplicationRecord
    extend Enumerize
    include Workflow
    include Authority::Abilities
    mount_uploader :image, FileUploader

    self.table_name = 'aml_client_documents'

    enumerize :workflow_state, in: %w[pending accepted rejected], scope: true

    scope :ordered, -> { order 'id desc' }

    belongs_to :document_kind, class_name: 'AML::DocumentKind', foreign_key: 'document_kind_id', inverse_of: :client_documents
    belongs_to :order, class_name: 'AML::Order', foreign_key: 'order_id', inverse_of: :client_documents
    has_many :client_document_fields, class_name: 'AML::ClientDocumentField', dependent: :destroy

    validates :image, presence: true
    validates :document_kind_id, uniqueness: { scope: :order_id }

    workflow do
      state :pending do
        event :accept, transitions_to: :accepted
        event :reject, transitions_to: :rejected
      end

      state :accepted do
        event :reject, transitions_to: :rejected
      end

      state :rejected do
        event :accept, transitions_to: :accepted
      end
    end

    after_create do
      order_loading
      add_fields
    end

    private

    def order_loading
      order.load! if order.none? && order.complete?
    end

    def add_fields
      field_definitions = document_kind.document_kind_field_definitions
      field_definitions.each do |field_definition|
        AML::ClientDocumentField.create!(definition: field_definition, client_document_id: id)
      end
    end
  end
end
