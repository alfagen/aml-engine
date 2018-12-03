# frozen_string_literal: true

FactoryBot.define do
  factory(:aml_operator, class: AML::Operator) do
    trait :administrator do
      role { 'administrator' }
    end

    trait :blocked do
      workflow_state { :blocked }
    end
  end
end
