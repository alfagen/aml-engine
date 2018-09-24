require 'spec_helper'

describe AML::StatusSerializer, type: :services do
  let(:aml_status) { create :aml_status }

  before do
    aml_status.aml_document_groups << create(:aml_document_group)
  end

  subject { described_class.new aml_status, include: described_class.relationships_to_serialize.keys }

  it { expect(subject.as_json).to be_a Hash }
end
