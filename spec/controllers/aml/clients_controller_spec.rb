require 'rails_helper'

RSpec.describe AML::ClientsController, type: :controller do
  let(:user) { create :aml_operator, :administrator }
  let!(:aml_status) { create :aml_status, key: 'guest' }
  let!(:aml_client) { create :aml_client, aml_status: aml_status }

  before { login_user user }

  it '#create' do
    post 'create', params: { aml_client: attributes_for(:aml_client, aml_status_id: aml_status.id) }
    expect(response).to be_redirect
  end

  it '#show' do
    get :show, params: { id: aml_client.id }
    expect(response).to be_successful
  end
  it '#index' do
    get :index
    expect(response).to be_successful
  end
end
