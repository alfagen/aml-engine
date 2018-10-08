require 'spec_helper'

describe AML::OrderSerializer, type: :services do
  let(:aml_status) { create :aml_status, :default }

  subject { described_class.new order, include: described_class.relationships_to_serialize.keys }

  context 'fresh order' do
    let(:order) { create :aml_order, aml_status: aml_status }
    it { expect(subject.as_json).to be_a Hash }
  end

  context 'rejected' do
    let(:order) { create :aml_order, :rejected, aml_status: aml_status, aml_reject_reason: create(:aml_reject_reason) }
    it { expect(subject.as_json).to be_a Hash }
  end
end
