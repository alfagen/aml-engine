class AML::OrderDocumentSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_order_document

  belongs_to :order, record_type: :aml_order
  belongs_to :document_kind, record_type: :aml_document_kind
  has_many :client_document_fields, record_type: :aml_client_document_fields

  attributes :order_id, :image,
    :client_document_fields_attributes, :fields,
    :workflow_state
end
