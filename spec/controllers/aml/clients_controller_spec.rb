require 'rails_helper'

RSpec.describe AML::ClientsController, type: :controller do
  routes { AML::Engine.routes }
  let(:operator) { create :aml_operator, :administrator }
  let(:aml_status) { create :aml_status, key: 'guest' }
  let(:aml_client) { create :aml_client, aml_status: aml_status }

  let(:user) { double aml_operator: operator }

  before do
    user.class.include Authority::Abilities
    user.class.include Authority::UserAbilities
    allow(controller).to receive(:current_user).and_return user
  end

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
