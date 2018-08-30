module AML
  class ClientDocumentField < ApplicationRecord
    scope :ordered, -> { order 'id desc' }

    belongs_to :client_document, class_name: 'AML::ClientDocument',
                                 foreign_key: 'client_document_id',
                                 inverse_of: :client_document_fields

    belongs_to :definition, class_name: 'AML::DocumentKindFieldDefinition',
                            foreign_key: :document_kind_field_definition_id,
                            inverse_of: :client_document_fields

    validates :document_kind_field_definition_id, uniqueness: { scope: :client_document_id }

    alias_attribute :definition_id, :document_kind_field_definition_id

    delegate :title, :key, to: :definition
  end
end
