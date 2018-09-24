require 'spec_helper'

describe AML::OrderSerializer, type: :services do
  let(:aml_status) { create :aml_status, :default }

	subject { create :aml_order, aml_status_id: aml_status.id }

  let(:serializer) { described_class.new subject, include: described_class.relationships_to_serialize.keys }
	it { expect(serializer.as_json).to be_a Hash }
end
