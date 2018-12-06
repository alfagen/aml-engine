require 'rails_helper'

RSpec.describe AML::DocumentGroupsController, type: :controller do
  routes { AML::Engine.routes }
  let(:aml_status) { create(:aml_status) }
  let(:aml_document_group) { create(:aml_document_group) }
  let(:user) { create :aml_operator, :administrator }

  before { login_user(user) }

  it '#create' do
    post 'create', params: { document_group: { title: 'title', details: 'details', position: 1 } }
    expect(response).to be_redirect
  end

  it '#upadte' do
    put 'update', params: { document_group: { title: 'new title', details: 'new details', position: 2 }, id: aml_document_group.id }
    expect(response).to be_redirect
  end

  it '#index' do
    get :index
    expect(response).to be_successful
  end
end
