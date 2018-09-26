FactoryBot.define do
  factory(:aml_document_kind, class: AML::DocumentKind) do
    sequence(:title) { |n| "title#{n}" }

    aml_document_group

    trait :with_definitions do
      after(:create) do |instance|
        create :aml_document_kind_field_definition, aml_document_kind: instance
        create :aml_document_kind_field_definition, aml_document_kind: instance
      end
    end
  end
end
