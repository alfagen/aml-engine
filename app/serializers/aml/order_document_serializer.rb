class AML::OrderDocumentSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_order_document

  belongs_to :order, record_type: :aml_order
  belongs_to :document_kind, record_type: :aml_document_kind
  belongs_to :aml_reject_reason, record_type: :aml_status, serializer: 'AML::RejectReasonSerializer'

  has_many :document_fields, record_type: :aml_document_fields

  attributes :order_id, :image,
    :document_fields_attributes, :fields,
    :workflow_state,
    :reject_reason_details

  attribute :reject_reason do |od|
    [od.aml_reject_reason.title, od.reject_reason_details].compact.join('. ') if od.rejected?
  end
end
