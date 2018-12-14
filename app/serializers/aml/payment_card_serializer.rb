class AML::PaymentCardSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_payment_card

  belongs_to :aml_client, record_type: :aml_client, serializer: 'AML::ClientSerializer'

  attributes :id, :aml_client_id, :card_bin, :card_suffix, :card_brand
end
