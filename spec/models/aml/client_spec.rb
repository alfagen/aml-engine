require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  subject { create :aml_client }

  it { expect(subject).to be_persisted }
  it { expect(subject.current_order).to be_persisted }

  context 'статус по-умолчанию' do
    let!(:default_status) { create :aml_status, key: AML.default_status_key }

    subject { create :aml_client, aml_status_id: nil }
    it { expect(subject.aml_status).to eq default_status }

    context 'присваиваем статус' do
      let(:aml_status) { create :aml_status }
      before do
        subject.update aml_status: aml_status
      end

      it { expect(subject.aml_status).to eq aml_status }
    end
  end
end
