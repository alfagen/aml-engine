FactoryBot.define do
  factory(:aml_document_group_to_status, class: AML::DocumentGroupToStatus) do
    association :aml_document_group, factory: :document_group
    association :aml_status, factory: :status
  end
end
