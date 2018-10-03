# frozen_string_literal: true

FactoryBot.define do
  factory(:aml_operator, class: AML::Operator) do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "operator#{n}" }

    trait :administrator do
      role { 'administrator' }
    end
  end
end
