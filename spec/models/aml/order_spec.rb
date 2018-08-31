require 'spec_helper'

RSpec.describe AML::Order, type: :model do
  subject { build :order }
  it { expect(subject).to be_valid }
end
