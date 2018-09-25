require 'spec_helper'

RSpec.describe AML, type: :model do
  context 'seed_demo!' do
    before do
      AML.seed_demo!
    end
    it { expect(AML::Status).to be_any }
  end
end
