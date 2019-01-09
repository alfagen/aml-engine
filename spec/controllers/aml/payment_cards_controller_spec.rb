require 'rails_helper'

RSpec.describe AML::PaymentCardsController, type: :controller do
  routes { AML::Engine.routes }
  let!(:aml_client) { create :aml_client, aml_status: create(:aml_status, key: AML.default_status_key) }
  let!(:aml_payment_card_order) { create :aml_payment_card_order, aml_client_id: aml_client.id }
  let(:aml_payment_card) { create :aml_payment_card, aml_client_id: aml_client.id, aml_payment_card_order_id: aml_payment_card_order.id}

  let(:operator) { create :aml_operator, :administrator }
  let(:user) { DummyUser.new }

  before { user_operator(user, operator) }

  it '#index' do
    get :index
    expect(response).to be_successful
  end
end
