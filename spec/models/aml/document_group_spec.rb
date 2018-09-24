require 'spec_helper'

RSpec.describe AML::DocumentGroup, type: :model do
  subject { create :aml_document_group }
  it { expect(subject).to be_persisted }
  it { expect(subject.aml_statuses).to be_empty }

  context 'привязываем к группе' do
    let(:aml_status) { create :aml_status }

    before do
      subject.aml_statuses << aml_status
    end

    it { expect(subject.aml_statuses).to be_one }
  end
end
