require 'rails_helper'

RSpec.describe AML::OrderRejectionsController, type: :controller do
  routes { AML::Engine.routes }
  let!(:status) { create :aml_status, :default }
  let(:order) { create :aml_order, :pending }
  let(:reject_reason) { create :aml_reject_reason, :order_reason }

  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { order_id: order.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #create' do
    it 'returns http success' do
      post :create, params: { order_id: order.id, aml_reject_reason_id: reject_reason.id }
      expect(response).to be_successful
    end
  end
end
