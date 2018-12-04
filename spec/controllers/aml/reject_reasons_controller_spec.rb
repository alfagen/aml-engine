require 'rails_helper'

RSpec.describe AML::RejectReasonsController, type: :controller do
  routes { AML::Engine.routes }
  let(:user) { create :user, :administrator }
  let(:aml_reason) { create(:aml_reject_reason, :order_reason) }
  let(:kind) { 'order_document_reason' }

  before { login_user(user) }

  it '#create' do
    post :create, params: { reject_reason: attributes_for(:aml_reject_reason) }
    expect(response).to be_redirect
  end

  it '#index' do
    get :index
    expect(response).to be_successful
  end

  it '#update' do
    put 'update', params: { id: aml_reason.id, reject_reason: { title: 'another title' } }
    expect(response).to be_redirect
  end

  it '#delete' do
    delete :destroy, params: { id: aml_reason.id }
    expect(response).to be_redirect
  end
end
