require 'spec_helper'

RSpec.describe AML::OrderCheck, type: :model do
  let!(:aml_status) { create :aml_status, :default }

  let(:order_check) { create :aml_order_check }

  it { expect(order_check).to be_persisted }
end
