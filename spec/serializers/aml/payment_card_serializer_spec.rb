require 'spec_helper'

describe AML::PaymentCardSerializer, type: :services do
  let!(:default_status) { create :aml_status, :default }
  let!(:aml_order) { create :aml_order }
  let(:aml_payment_card) { create :aml_payment_card, aml_client_id: aml_order.client.id, aml_order_id: aml_order.id}

  subject { described_class.new aml_payment_card, include: described_class.relationships_to_serialize.keys }

  it { expect(subject.as_json).to be_a Hash }
end
