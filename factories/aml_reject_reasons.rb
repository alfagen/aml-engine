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

    trait :payment_card_order_reason do
      kind { 'card_order_reason' }
    end
  end
end
