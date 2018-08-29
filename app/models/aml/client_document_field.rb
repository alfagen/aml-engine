module AML
  class ClientDocumentField < ApplicationRecord
    scope :ordered, -> { order 'id desc' }

    self.table_name = 'aml_client_document_fields'

    belongs_to :client_document, class_name: 'AML::ClientDocument', foreign_key: 'client_document_id', inverse_of: :client_document_fields
    belongs_to :definition, class_name: 'AML::DocumentKindFieldDefinition',
                            foreign_key: :document_kind_field_definition_id, inverse_of: :client_document_fields

    validates :document_kind_field_definition_id, uniqueness: { scope: :client_document_id }

    delegate :title, to: :definition
  end
end
