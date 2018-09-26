FactoryBot.define do
  sequence(:title) { |n| "title#{n}" }
  sequence(:key) { |n| "key#{n}" }
  factory(:aml_status, class: AML::Status) do
    title { generate :title }
    key { generate :key }

    trait :default do
      key { AML.default_status_key }
    end
  end
end
