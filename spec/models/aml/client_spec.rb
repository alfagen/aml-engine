require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  # также нужен для заявки
  let(:template_id ) { SecureRandom.hex(6) }
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
      @saved_order = subject.current_order
      subject.reset_status!
    end

    it { expect(subject.aml_status).to be_nil }
    it { expect(subject.current_order).to_not eq @saved_order }
  end

  describe 'risk category' do
    it { expect(subject.risk_category).to be_nil }

    it do
      subject.update! risk_category: 'A'
      expect(subject.risk_category).to eq 'A'
    end
  end

  describe 'отправка уведомления клиенту' do
    it 'c template_id уведомления' do
      expect{subject.notify(template_id)}.to change{ActionMailer::Base.deliveries.count}
      expect(ActionMailer::Base.deliveries.last.to).to eq [subject.email]
    end
  end
end
