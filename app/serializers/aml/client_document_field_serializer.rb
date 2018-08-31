class AML::ClientDocumentFieldSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_client_document_field

  belongs_to :definition, record_type: :aml_document_kind_field_definition

  attributes :value
end
