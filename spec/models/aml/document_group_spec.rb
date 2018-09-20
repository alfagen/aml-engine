require 'spec_helper'

RSpec.describe AML::DocumentGroup, type: :model do
  subject { create :document_group }
  it { expect(subject).to be_persisted }
  it { expect(subject.aml_statuses).to be_empty }

  context 'привязываем к группе' do
    let(:status) { create :status }

    before do
      subject.aml_statuses << status
    end

    it { expect(subject.aml_statuses).to be_one }
  end
end
