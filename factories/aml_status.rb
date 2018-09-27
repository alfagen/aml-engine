FactoryBot.define do
  sequence(:aml_status_title) { |n| "title#{n}" }
  sequence(:aml_status_key) { |n| "key#{n}" }
  factory(:aml_status, class: AML::Status) do
    title { generate :aml_status_title }
    key { generate :aml_status_key }

    trait :default do
      key { AML.default_status_key }
    end
  end
end
