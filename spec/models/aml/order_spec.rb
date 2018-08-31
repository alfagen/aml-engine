require 'spec_helper'

RSpec.describe AML::Order, type: :model do
  before do
    create :document_kind
  end

  subject { create :order }

  it { expect(subject).to be_persisted }
  it { expect(subject.order_documents).to be_one }
end
