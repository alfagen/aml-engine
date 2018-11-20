require 'rails_helper'

RSpec.describe AML::OrdersController, type: :controller do
  render_views

  let!(:aml_status) { create :aml_status, :default }
  let!(:aml_order) { create :aml_order }

  before { login_user user }

  describe 'оператор' do
    let(:user) { create :aml_operator }

    it '#show' do
      get :show, params: { id: aml_order.id }
      expect(response).to be_successful
    end

    it '#index' do
      get :index, params: { workflow_state: 'processing' }
      expect(response).to be_successful
    end
  end

  describe 'administartor' do
    let(:user) { create(:aml_operator, role: 'administrator') }

    it '#create' do
      post :create, params: { order: attributes_for(:aml_order) }

      expect(response).to be_successful
    end
  end
end
