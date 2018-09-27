class AML::DocumentGroupSerializer
  include FastJsonapi::ObjectSerializer
  set_type :aml_document_group

  has_many :aml_document_kinds, record_type: :aml_document_kind, serializer: 'AML::DocumentKindSerializer'

  attributes :title, :position, :details
end
