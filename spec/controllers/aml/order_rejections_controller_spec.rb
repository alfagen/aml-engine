require 'rails_helper'

RSpec.describe AML::OrderRejectionsController, type: :controller do
  routes { AML::Engine.routes }
  let(:administrator) { create(:aml_operator, :administrator) }
  let!(:status) { create :aml_status, :default }
  let(:order) { create :aml_order, :processing }
  let(:reject_reason) { create :aml_reject_reason, :order_reason }

  before { login_user(administrator) }

  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { order_id: order.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'returns http redirected' do
      post :create, params: { order:{ aml_reject_reason_id: reject_reason.id, reject_reason_details: 'test' }, order_id: order.id }
      expect(response).to be_redirect
    end
  end
end
