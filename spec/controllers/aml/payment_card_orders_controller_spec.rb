require 'rails_helper'

RSpec.describe AML::PaymentCardOrdersController, type: :controller do
  routes { AML::Engine.routes }
  render_views

  let!(:default_status) { create :aml_status, :default }
  let!(:aml_client) { create :aml_client }
  let(:aml_payment_card_order) { create :aml_payment_card_order, aml_client_id: aml_client.id}

  let(:operator) { create :aml_operator, :administrator }
  let(:user) { DummyUser.new(aml_operator: operator) }

  before { allow(controller).to receive(:current_user).and_return user }

  describe 'actions' do
    it '#show' do
      get :show, params: { id: aml_payment_card_order.id }
      expect(response).to be_successful
    end

    it '#index' do
      get :index, params: { workflow_state: :loaded }
      expect(response).to be_successful
    end
  end
end
