require 'spec_helper'

RSpec.describe AML::Operator, type: :model do
  let!(:operator) { create :aml_operator }
  let(:password) { generate :aml_password }

  before do
    operator.change_password! password
  end

  it { expect(operator.valid_password? password) }
end
