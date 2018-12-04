require 'spec_helper'

RSpec.describe AML::Operator, type: :model do
  let!(:user) { create :user }
  let(:password) { generate :aml_password }

  before do
    user.change_password! password
  end

  it { expect(user.valid_password? password) }
end
