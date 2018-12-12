require 'spec_helper'

RSpec.describe AML::PaymentCard, type: :model do
  let!(:aml_client) { create :aml_client, aml_status: create(:aml_status, key: AML.default_status_key) }
  let!(:aml_payment_card_order) { create :aml_payment_card_order, aml_client_id: aml_client.id }
  let(:aml_payment_card) { create :aml_payment_card, aml_client_id: aml_client.id, aml_payment_card_order_id: aml_payment_card_order.id}

  it { expect(aml_payment_card).to be_persisted }
end
