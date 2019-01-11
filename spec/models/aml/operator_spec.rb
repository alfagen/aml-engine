require 'spec_helper'

RSpec.describe AML::Operator, type: :model do
  subject(:operator) { create :aml_operator }
  it { expect(operator).to be_persisted }
end
