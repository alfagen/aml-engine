require 'rails_helper'

RSpec.describe AML::DocumentKindFieldDefinitionsController, type: :controller do
  routes { AML::Engine.routes }
  let(:aml_document_kind_field_definition) { create(:aml_document_kind_field_definition) }
  let(:aml_document_kind)                  { aml_document_kind_field_definition.document_kind }
  let(:aml_document_group) { aml_document_kind.document_group }

  let(:operator) { create :aml_operator, :administrator }
  let(:user) { double aml_operator: operator }

  before { user_authority(user, controller) }

  it '#create' do
    post :create, params: {
      document_group_id: aml_document_group.id,
      document_kind_id: aml_document_kind.id,
      document_kind_field_definition: attributes_for(:aml_document_kind_field_definition)
    }
    expect(response).to be_redirect
  end

  it '#update' do
    put :update, params: {
      document_group_id: aml_document_group.id,
      document_kind_id: aml_document_kind.id,
      id: aml_document_kind_field_definition.id,
      document_kind_field_definition: { key: 'newkey', title: 'newtitle', document_kind_id: aml_document_kind.id }
    }
    expect(response).to be_redirect
  end
end
