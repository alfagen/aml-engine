FactoryBot.define do
  factory(:document_kind, class: AML::DocumentKind) do
    sequence(:title) { |n| "title#{n}" }

    # title { generate :title }

    trait :with_definitions do
      after(:create) do |instance|
        create :document_kind_field_definition, document_kind: instance
        create :document_kind_field_definition, document_kind: instance
      end
    end
  end
end
