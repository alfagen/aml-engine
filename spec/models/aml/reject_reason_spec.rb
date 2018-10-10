require 'spec_helper'

RSpec.describe AML::RejectReason, type: :model do
  let!(:aml_reject_reason) { create :aml_reject_reason, :order_reason }

  it { expect(aml_reject_reason).to be_persisted }
end
