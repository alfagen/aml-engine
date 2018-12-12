require 'spec_helper'

describe AML::PaymentCardSerializer, type: :services do
  let!(:aml_client) { create :aml_client, aml_status: create(:aml_status, key: AML.default_status_key) }
  let!(:aml_payment_card_order) { create :aml_payment_card_order, aml_client_id: aml_client.id }
  let(:aml_payment_card) { create :aml_payment_card, aml_client_id: aml_client.id, aml_payment_card_order_id: aml_payment_card_order.id}

  subject { described_class.new aml_payment_card, include: described_class.relationships_to_serialize.keys }

  it { expect(subject.as_json).to be_a Hash }
end
