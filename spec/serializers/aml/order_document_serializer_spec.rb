require 'spec_helper'

describe AML::OrderDocumentSerializer, type: :services do
  subject { create :aml_order_document }

  let(:serializer) { described_class.new subject, include: described_class.relationships_to_serialize.keys }
  it { expect(serializer.as_json).to be_a Hash }
end
