require 'rails_helper'

RSpec.describe AML::DocumentFieldsController, type: :controller do
  routes { AML::Engine.routes }
  let!(:aml_status) { create(:aml_status, key: 'guest') }
  let!(:aml_document_field) { create(:aml_document_field) }

  let(:operator) { create :aml_operator, :administrator }

  let(:user) { double aml_operator: operator }

  before do
    user.class.include Authority::Abilities
    user.class.include Authority::UserAbilities
    allow(controller).to receive(:current_user).and_return user
  end

  context '#update' do
    it 'update' do
      put 'update', params: { id: aml_document_field.id, value: 'another value' }
      expect(response).to be_redirect
    end
  end
end
