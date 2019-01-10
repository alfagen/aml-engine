require 'rails_helper'

RSpec.describe AML::StatusesController, type: :controller do
  routes { AML::Engine.routes }
  describe '#base actions' do
    let(:aml_status) { create(:aml_status) }

    let(:operator) { create :aml_operator, :administrator }
    let(:user) { DummyUser.new(aml_operator: operator) }

    before { allow(controller).to receive(:current_user).and_return user }

    context 'with registered administrator' do
      it '#create' do
        post :create, params: { aml_status: attributes_for(:aml_status) }
        expect(response).to be_successful
      end

      it '#index' do
        get :index
        expect(response).to be_successful
      end

      it '#show' do
        get :show, params: { id: aml_status.id }
        expect(response).to be_successful
      end
    end
  end
end
