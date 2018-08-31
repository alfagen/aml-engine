require 'spec_helper'

RSpec.describe AML::Client, type: :model do
  subject { create :client }
  it { expect(subject).to be_persisted }
  it { expect(subject.current_order).to be_persisted }
end
