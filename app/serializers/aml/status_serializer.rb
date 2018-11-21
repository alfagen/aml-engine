class AML::StatusSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_status

  has_many :aml_document_groups, record_type: :aml_document_group, serializer: 'AML::DocumentGroupSerializer'

  attributes :title, :position, :details, :key, :card_required
end
