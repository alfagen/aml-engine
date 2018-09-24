FactoryBot.define do
  factory(:aml_document_group, class: AML::DocumentGroup) do
    sequence(:title) { |n| "title#{n}" }

    trait :with_kinds do
      after(:create) do |instance|
        create :aml_document_kind, document_group: instance
        create :aml_document_kind, document_group: instance
      end
    end
  end
end
