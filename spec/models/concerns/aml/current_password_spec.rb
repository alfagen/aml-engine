require 'spec_helper'

RSpec.describe AML::CurrentPassword, type: :model do
  context 'создавать можно без пароля' do
    let(:operator) { build :aml_operator }

    it { expect(operator.save!).to be_truthy }
  end

  context 'легко изменить пароль когда оператор без пароля' do
    let(:operator) { create :aml_operator, password: nil }

    it { expect(operator).to be_persisted }

    context do
      let(:new_password) { generate :aml_password }
      before do
        operator.update password: new_password
      end

      it { expect(operator.valid_password? new_password).to be_truthy }
    end
  end

  context 'создание пароля при регистрации не требует текущего пароля' do
    let(:password) { generate :aml_password }
    let(:operator) { create :aml_operator }

    it { expect(operator).to be_valid }
    it do
      expect { operator.update! password: password, password_confirmation: password }.to_not raise_error
    end
  end

  context 'создаем оператора с паролем' do
    let(:password) { generate :aml_password }
    let(:operator) { create :aml_operator, password: password, password_confirmation: password }
    it { expect(operator.valid_password? password).to be_truthy }

    context 'не дает изменить пароль без current_password' do
      let(:new_password) { generate :aml_password }
      before do
        operator.assign_attributes password: new_password, password_confirmation: new_password
      end

      it do
        expect(operator).to_not be_valid
        expect(operator.errors.keys).to include :current_password
      end
    end

    context 'не дает изменить пароль с неверным current_password' do
      let(:new_password) { generate :aml_password }
      before do
        operator.assign_attributes password: new_password, password_confirmation: new_password, current_password: 'wrong'
      end

      it do
        expect(operator).to_not be_valid
        expect(operator.errors.keys).to include :current_password
      end
    end

    context 'дает изменить пароль с верным current_password' do
      let(:new_password) { generate :aml_password }
      before do
        operator.assign_attributes password: new_password, password_confirmation: new_password, current_password: password
      end

      it { expect(operator).to be_valid }
    end
  end
end
