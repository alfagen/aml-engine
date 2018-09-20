require 'spec_helper'

RSpec.describe AML::Status, type: :model do
  subject { create :status }
  it { expect(subject).to be_persisted }
  it { expect(subject.aml_document_groups).to be_empty }

  context 'привязываем к группе' do
    let(:document_group) { create :document_group }

    before do
      subject.aml_document_groups << document_group
    end

    it { expect(subject.aml_document_groups).to be_one }
  end
end
