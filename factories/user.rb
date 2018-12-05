# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "operator#{n}" }
    aml_operator

    trait :administrator do
      association :aml_operator, :administrator
    end
  end
end
