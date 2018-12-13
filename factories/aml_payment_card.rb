FactoryBot.define do
  factory(:aml_payment_card, class: AML::PaymentCard) do
    brand { 'VISA' }
    bin { '123456' }
    suffix { '1234' }
    association :aml_client, factory: :aml_client
    association :aml_payment_card_order, factory: :aml_payment_card_order
  end
end
