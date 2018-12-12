FactoryBot.define do
  factory(:aml_payment_card, class: AML::PaymentCard) do
    brand { 'card_brand' }
    bin { '111111' }
    suffix { '1111' }
    association :aml_client, factory: :aml_client
    association :aml_order, factory: :aml_order
  end
end
