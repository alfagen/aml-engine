require 'rails_helper'

RSpec.describe AML::OperatorsController, type: :controller do
  routes { AML::Engine.routes }
  let(:operator) { create(:aml_operator, role: 'operator') }
  let(:test_operator) { create(:aml_operator, role: 'operator') }

  let(:operator) { create :aml_operator, :administrator }
  let(:user) { DummyUser.new(aml_operator: operator) }

  before { allow(controller).to receive(:current_user).and_return user }

  context 'администратор может' do
    it '#create создавать операторов' do
      post :create, params: { operator: test_operator.attributes }
      expect(response.status).to eq(200)
    end

    it '#update редактировать операторов' do
      put :update, params: { id: test_operator.id, operator: { email: 'new@mail.com' } }
      expect(response.status).to eq(200)
    end
  end
end
