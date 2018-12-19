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

    context 'when accepts' do
      let(:operator) { create :aml_operator }
      before do
        order.start! operator: operator
        order.accept!
      end

      it { expect(order.aml_payment_card).to be_persisted }
      it { expect(AML::PaymentCard.count).to eq 1 }

      context 'when accepts other orider with same card for same client' do
        let(:operator) { create :aml_operator }
        let(:order2) { create :aml_payment_card_order, aml_client_id: aml_client.id }
        before do
          order2.update_attribute :image, image
          order2.start! operator: operator
          order2.accept!
        end

        it { expect(order2.aml_payment_card).to be_nil }
        it { expect(AML::PaymentCard.count).to eq 1 }
      end
    end
  end
end
