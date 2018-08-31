class AML::DocumentKindFieldDefinitionSerializer
  include FastJsonapi::ObjectSerializer
  set_type :aml_document_kind_field_definition

  attributes :title, :key, :position
end
