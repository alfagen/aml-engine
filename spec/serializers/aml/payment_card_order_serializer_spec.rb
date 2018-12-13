require 'spec_helper'

describe AML::PaymentCardOrderSerializer, type: :services do
  let!(:aml_status) { create :aml_status, :default }

  subject { described_class.new order, include: described_class.relationships_to_serialize.keys }

  context 'fresh order' do
    let(:order) { create :aml_payment_card_order }
    it { expect(subject.as_json).to be_a Hash }
  end

  context 'rejected' do
    let(:order) { create :aml_payment_card_order, :rejected }
    it { expect(subject.as_json).to be_a Hash }
  end
end
