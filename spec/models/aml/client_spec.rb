require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  # также нужен для заявки
  let!(:default_status) { create :aml_status, :default }
  it 'проверочка' do
    expect(default_status).to eq AML.default_status
  end

  subject { create :aml_client }

  it { expect(subject).to be_persisted }
  it { expect(subject.aml_status).to be_nil }
  it { expect(subject.current_order).to be_persisted }

  context 'статус можно сбросить' do
    before do
      subject.reset_status!
    end

    it { expect(subject.aml_status).to eq default_status }
  end
end
