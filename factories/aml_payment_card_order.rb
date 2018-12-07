FactoryBot.define do
  factory(:aml_payment_card_order, class: AML::PaymentCardOrder) do
    card_brand { 'card_brand' }
    card_bin { 'card_bin' }
    card_suffix { 'card_suffix' }
    association :client, factory: :aml_client

    trait :none do
      workflow_state { :none }
      image { nil }
    end

    trait :loaded do
      workflow_state { :loaded }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
    end

    trait :accepted do
      workflow_state { :accepted }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
    end

    trait :rejected do
      workflow_state { :loaded }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
      after :create do |payment_card_order|
        payment_card_order.reject!
      end
    end
  end
end
