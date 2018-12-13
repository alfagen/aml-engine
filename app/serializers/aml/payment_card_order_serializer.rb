module AML
  class PaymentCardOrderSerializer
    include FastJsonapi::ObjectSerializer

    set_type :aml_payment_card_order

    belongs_to :aml_reject_reason, record_type: :aml_status, serializer: 'AML::RejectReasonSerializer'

    attributes :workflow_state, :reject_reason_details, :created_at, :updated_at

    attributes :card_brand, :card_bin, :card_suffix

    attribute :reject_reason do |o|
      [o.aml_reject_reason.title, o.reject_reason_details].compact.join('. ') if o.rejected?
    end
  end
end
