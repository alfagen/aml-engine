FactoryBot.define do
  factory(:aml_payment_card_order, class: AML::PaymentCardOrder) do
    card_brand { 'VISA' }
    card_bin { '123456' }
    card_suffix { '1234' }
    association :client, factory: :aml_client
    association :operator, factory: [:aml_operator, :administrator]

    trait :none do
      workflow_state { :none }
    end

    trait :pending do
      after :create do |payment_card_order|
        image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
        payment_card_order.done!
      end
    end

    trait :processing do
      after :create do |payment_card_order|
        image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
        payment_card_order.done!
        payment_card_order.start!(operator: operator)
      end
    end

    trait :accepted do
      after :create do |payment_card_order|
        image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
        payment_card_order.done!
        payment_card_order.start!(operator: operator)
        payment_card_order.accept!
      end
    end

    trait :rejected do
      after :create do |payment_card_order|
        image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
        payment_card_order.done!
        payment_card_order.start!(operator: operator)
        payment_card_order.reject!(reject_reason: create(:aml_reject_reason, :payment_card_order_reason), details: 'reject reason details')
      end
    end
  end
end
