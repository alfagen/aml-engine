FactoryBot.define do
  factory(:aml_document_kind_field_definition, class: AML::DocumentKindFieldDefinition) do
    sequence(:title) { |n| "title#{n}" }
    sequence(:key) { |n| "key#{n}" }

    #key { generate :key }
    #title { generate :title }
    association :document_kind, factory: :aml_document_kind
  end
end
