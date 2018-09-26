class AML::OrderDocumentSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_order_document

  belongs_to :aml_order, record_type: :aml_order, serializer: 'AML::OrderSerializer'
  belongs_to :aml_document_kind, record_type: :aml_document_kind, serializer: 'AML::DocumentKindSerializer'
  has_many :aml_document_fields, record_type: :aml_document_fields, serializer: 'AML::DocumentFieldSerializer'

  attributes :aml_order_id, :image,
    :document_fields_attributes, :fields,
    :workflow_state
end
