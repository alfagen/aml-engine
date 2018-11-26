require 'rails_helper'

RSpec.describe AML::DocumentKindsController, type: :controller do
  routes { AML::Engine.routes }
  describe '#base actions' do
    let(:user) { create :aml_operator, :administrator }
    let(:aml_document_group) { create(:aml_document_group) }
    let(:aml_document_kind) { create(:aml_document_kind) }

    before { login_user(user) }

    context 'with registered operator' do
      it '#create' do
        post :create, params: {
          document_group_id: aml_document_group.id,
          document_kind: attributes_for(:aml_document_kind)
        }
        expect(response).to be_redirect
      end

      it '#update' do
        put :update, params: {
          id: aml_document_kind.id,
          document_group_id: aml_document_group.id,
          document_kind: { aml_document_group_id: aml_document_kind.aml_document_group_id,
                           title: 'new title',
                           details: 'new details', position: 2 }
        }
        expect(response).to be_redirect
      end

      it '#index' do
        get :index, params: {
          document_group_id: aml_document_group.id
        }
        expect(response).to be_redirect
      end

      it '#show' do
        get :show, params: {
          document_group_id: aml_document_group.id,
          id: aml_document_kind.id
        }
        expect(response).to be_redirect
      end
    end
  end
end
