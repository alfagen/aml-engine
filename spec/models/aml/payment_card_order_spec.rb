require 'spec_helper'

RSpec.describe AML::PaymentCardOrder, type: :model do
  let!(:default_status) { create :aml_status, :default }
  let(:aml_client) { create :aml_client }
  let(:aml_payment_card_order) { create :aml_payment_card_order, aml_client_id: aml_client.id}

  it { expect(aml_payment_card_order).to be_persisted }
end
