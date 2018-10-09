class AML::DocumentKindSerializer
  include FastJsonapi::ObjectSerializer
  set_type :aml_document_kind

  has_many :definitions, record_type: :aml_document_kind_field_definition

  belongs_to :document_group, record_type: :aml_document_group

  attributes :title, :position, :details, :file, :file_title
end
