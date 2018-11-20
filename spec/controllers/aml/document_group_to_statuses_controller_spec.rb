require 'rails_helper'

RSpec.describe AML::DocumentGroupToStatusesController, type: :controller do
  let(:aml_status) { create(:aml_status) }
  let(:aml_document_group) { create(:aml_document_group) }
  let(:administrator) { create(:aml_operator, role: 'administrator') }

  describe 'actions' do
    before { login_user(administrator) }

    context '#create' do
      it 'should create' do
        post 'create', params: { aml_document_group_to_status: { aml_status_id: aml_status.id, aml_document_group_id: aml_document_group.id } }
        expect(response).to be_redirect
      end
    end
  end
end
