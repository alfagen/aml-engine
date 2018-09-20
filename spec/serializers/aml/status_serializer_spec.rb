require 'spec_helper'

describe AML::StatusSerializer, type: :services do
  let(:status) { create :status }

  before do
    status.aml_document_groups << create(:document_group)
  end

  subject { described_class.new status, include: described_class.relationships_to_serialize.keys }

  it { expect(subject.as_json).to be_a Hash }
end
