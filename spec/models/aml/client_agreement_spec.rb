require 'spec_helper'

RSpec.describe AML::ClientAgreement, type: :model do
  let!(:default_status) { create :aml_status, :default }
  let(:client_agreement) { create :aml_client_agreement}

  it { expect(client_agreement).to be_persisted }
end
