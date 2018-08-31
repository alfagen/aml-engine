FactoryBot.define do
  factory(:document_kind_field_definition, class: AML::DocumentKindFieldDefinition) do
    sequence(:title) { |n| "title#{n}" }
    sequence(:key) { |n| "key#{n}" }
    document_kind
  end
end
