require 'spec_helper'

RSpec.describe AML::OrderDocument, type: :model do
  let(:order) { create :order }

  subject { create :order_document, order: order, document_kind: document_kind }

  context 'вид документа без полей' do
    let(:document_kind) { create :document_kind }
    it { expect(subject).to be_none }
    it { expect(subject.client_document_fields).to be_empty }

    describe 'загружаем документ' do
      before do
        subject.update image: Rack::Test::UploadedFile.new(Rails.root.join('test_files', 'test.png'))
      end
      it { expect(subject).to be_loaded }
    end
  end

  describe 'с полями' do
    let(:document_kind) { create :document_kind, :with_definitions }
    let(:definition) { document_kind.definitions.take }
    let(:key) { definition.key }
    let(:value) { generate :value }
    let(:fields) { { key => value } }

    it 'если в виде документа есть дефиниции, то под них создаются поля' do
      expect(subject.client_document_fields).to be_many
      expect(subject.fields.values.compact).to be_empty
    end

    it do
      expect { subject.fields = {} }.to_not raise_error
    end

    it 'устанавливаем поля через fields=' do
      subject.fields = fields

      expect(subject.fields).to eq fields
      expect(subject.fields.values.compact).to_not be_empty

      subject.save!

      expect(subject.fields).to eq fields
      expect(subject.fields.values.compact).to_not be_empty

      subject.reload

      expect(subject.fields).to eq fields
      expect(subject.fields.values.compact).to_not be_empty
    end

    describe 'документ на обработки' do
      before do
        order.update_column :workflow_state, :processing
      end

      it do
        expect { subject.save }.to raise_error AML::OrderDocument::ClosedOrderError
      end

      it do
        expect { subject.fields = {} }.to raise_error AML::OrderDocument::ClosedOrderError
      end
    end
  end
end
