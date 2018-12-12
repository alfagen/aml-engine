require 'spec_helper'

RSpec.describe AML::PaymentCard, type: :model do
  let!(:default_status) { create :aml_status, :default }
  let!(:aml_client) { create :aml_client }
  let!(:aml_order) { create :aml_order }
  let(:aml_payment_card) { create :aml_payment_card, aml_client_id: aml_client.id, aml_order_id: aml_order.id}

  it { expect(aml_payment_card).to be_persisted }
end
