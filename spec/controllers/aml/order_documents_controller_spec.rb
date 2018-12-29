require 'rails_helper'

RSpec.describe AML::OrderDocumentsController, type: :controller do
  routes { AML::Engine.routes }
  describe '#actions' do
    let!(:aml_status) { create(:aml_status, key: 'guest') }
    let(:aml_document_kind) { create(:aml_document_kind) }

    let(:aml_order) { create :aml_order }
    let(:aml_order_document) { create :aml_order_document, order: aml_order }

    let(:operator) { create :aml_operator, :administrator }
    let(:user) { double aml_operator: operator }

    before { user_authority(user, controller) }

    it '#update' do
      put 'update', params: {
        order_document: {
          image: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png'))
        },
        id: aml_order_document.id
      }
    end

    it '#show' do
      get :show, params: { id: aml_order_document.id }
      expect(response).to be_successful
    end
  end
end
