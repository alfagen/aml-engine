class AML::DocumentKindSerializer
  include FastJsonapi::ObjectSerializer
  set_type :aml_document_kind

  has_many :aml_definitions, record_type: :aml_document_kind_field_definition, serializer: 'AML::DocumentKindFieldDefinitionSerializer'

  belongs_to :aml_document_group, record_type: :aml_document_group, serializer: 'AML::DocumentGroupSerializer'

  attributes :title, :position, :details
end
