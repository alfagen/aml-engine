require 'spec_helper'

RSpec.describe AML::ClientInfo, type: :model do
  # также нужен для заявки
  let!(:default_status) { create :aml_status, :default }

  let(:client) { create :aml_client }

  let(:info) { client.create_aml_client_info }

  it { expect(info).to be_persisted }
end
