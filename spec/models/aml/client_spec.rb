require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  # также нужен для заявки
  let!(:default_status) { create :aml_status, :default }
  it 'проверочка' do
    expect(default_status).to eq AML.default_status
  end

  let(:aml_client) { create :aml_client }

  it { expect(aml_client).to be_persisted }
  it { expect(aml_client.aml_status).to be_nil }
  it { expect(aml_client.current_order).to be_persisted }

  context 'статус можно сбросить' do
    before do
      @saved_order = aml_client.current_order
      aml_client.reset_status!
    end

    it { expect(aml_client.aml_status).to be_nil }
    it { expect(aml_client.current_order).to_not eq @saved_order }
  end

  describe 'risk category' do
    it { expect(aml_client.risk_category).to be_nil }

    it do
      aml_client.update! risk_category: 'A'
      expect(aml_client.risk_category).to eq 'A'
    end
  end

  describe 'отправка уведомления клиенту' do
    it 'c template_id уведомления' do
      expect{aml_client.notify('any_id')}.to change{ActionMailer::Base.deliveries.count}
      expect(ActionMailer::Base.deliveries.last.to).to eq [aml_client.email]
    end
  end
end
