require 'spec_helper'

RSpec.describe AML::Agreement, type: :model do
  let(:agreement) { create :aml_agreement}

  it { expect(agreement).to be_persisted }
end
