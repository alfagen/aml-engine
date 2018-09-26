module AML
  class DocumentField < ApplicationRecord
    scope :ordered, -> { order 'id desc' }

    belongs_to :aml_order_document, class_name: 'AML::OrderDocument',
                                    foreign_key: 'order_document_id',
                                    inverse_of: :aml_document_fields

    belongs_to :aml_definition, class_name: 'AML::DocumentKindFieldDefinition',
                                foreign_key: 'document_kind_field_definition_id',
                                inverse_of: :aml_document_fields

    validates :document_kind_field_definition_id, uniqueness: { scope: :order_document_id }

    delegate :title, :key, to: :aml_definition
  end
end
