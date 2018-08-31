class AML::DocumentKindSerializer
  include FastJsonapi::ObjectSerializer
  set_type :aml_document_kind

  has_many :definitions, record_type: :aml_document_kind_field_definition

  attributes :title, :position
end
