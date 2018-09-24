require 'spec_helper'

describe AML::OrderSerializer, type: :services do
	subject { create :aml_order }

  let(:serializer) { described_class.new subject, include: described_class.relationships_to_serialize.keys }
	it { expect(serializer.as_json).to be_a Hash }
end
