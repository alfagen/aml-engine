FactoryBot.define do
  factory(:aml_reject_reason, class: AML::RejectReason) do
    sequence(:title) { |n| "title#{n}" }

    kind { 'order_reason' }

    trait :order_reason do
      kind { 'order_reason' }
    end

    trait :order_document_reason do
      kind { 'order_document_reason' }
    end
  end
end
