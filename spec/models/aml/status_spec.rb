require 'spec_helper'

RSpec.describe AML::Status, type: :model do
  subject { create :aml_status }
  it { expect(subject).to be_persisted }
  it { expect(subject.aml_document_groups).to be_empty }
  it { expect(subject.document_kinds).to be_empty }

  context 'привязываем к группе' do
    let(:aml_document_group) { create :aml_document_group }

    before do
      subject.aml_document_groups << aml_document_group
    end

    it { expect(subject.aml_document_groups).to be_one }
  end
end
