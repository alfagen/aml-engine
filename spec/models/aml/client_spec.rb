require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  subject { create :client }
  it { expect(subject).to be_persisted }
  it { expect(subject.current_order).to be_persisted }

  context 'присваиваем статус' do
    let(:aml_status) { create :status }
    before do
      subject.update aml_status: aml_status
    end

    it { expect(subject.aml_status).to eq aml_status }
  end
end
