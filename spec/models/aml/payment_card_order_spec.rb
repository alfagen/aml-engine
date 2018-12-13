require 'spec_helper'

RSpec.describe AML::PaymentCardOrder, type: :model do
  let!(:default_status) { create :aml_status, :default }
  let(:aml_client) { create :aml_client }
  subject(:order) { create :aml_payment_card_order, aml_client_id: aml_client.id}

  it { expect(order).to be_persisted }
  it { expect(order).to be_none }

  context 'when upload image' do
    let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }

    before do
      order.update_attribute :image, image
    end

    it { expect(order.reload).to be_pending }
  end
end
