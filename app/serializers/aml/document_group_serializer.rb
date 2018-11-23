class AML::DocumentGroupSerializer
  include FastJsonapi::ObjectSerializer
  set_type :aml_document_group

  has_many :document_kinds, record_type: :aml_document_kind

  attributes :title, :position, :details, :card_required
end
