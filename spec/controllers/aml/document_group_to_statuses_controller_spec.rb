require 'rails_helper'

RSpec.describe AML::DocumentGroupToStatusesController, type: :controller do
  routes { AML::Engine.routes }
  let(:aml_status) { create(:aml_status) }
  let(:aml_document_group) { create(:aml_document_group) }
  let(:operator) { create :aml_operator, :administrator }
  let(:user) { DummyUser.new }

  before { user_operator(user, operator) }

  describe 'actions' do
    context '#create' do
      it 'should create' do
        post 'create', params: { aml_document_group_to_status: { aml_status_id: aml_status.id, aml_document_group_id: aml_document_group.id } }
        expect(response).to be_redirect
      end
    end
  end
end
