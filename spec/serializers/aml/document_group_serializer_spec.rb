require 'spec_helper'

describe AML::DocumentGroupSerializer, type: :services do
  subject { create :document_group, :with_kinds }

  let(:serializer) { described_class.new subject, include: described_class.relationships_to_serialize.keys }
  it { expect(serializer.as_json).to be_a Hash }
end
