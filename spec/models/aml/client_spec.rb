require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  subject { create :client }

  it { expect(subject).to be_persisted }
  it { expect(subject.current_order).to be_persisted }

  context 'статус по-умолчанию' do
    let!(:default_status) { create :status, key: AML.default_status_key }

    subject { create :client, aml_status_id: nil }
    it { expect(subject.aml_status).to eq default_status }

    context 'присваиваем статус' do
      let(:aml_status) { create :status }
      before do
        subject.update aml_status: aml_status
      end

      it { expect(subject.aml_status).to eq aml_status }
    end
  end
end
