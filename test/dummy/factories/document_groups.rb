FactoryBot.define do
  factory(:document_group, class: AML::DocumentGroup) do
    sequence(:title) { |n| "title#{n}" }

    trait :with_kinds do
      after(:create) do |instance|
        create :document_kind, document_group: instance
        create :document_kind, document_group: instance
      end
    end
  end
end
