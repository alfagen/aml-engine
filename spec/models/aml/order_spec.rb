require 'spec_helper'

RSpec.describe AML::Order, type: :model do
  let(:aml_status) { create :aml_status, :default }

  before { create :aml_document_kind }

  subject { create :aml_order, aml_status_id: aml_status.id }

  it { expect(subject).to be_persisted }
  it { expect(subject).to be_none }
  it { expect(subject.aml_order_documents).to be_one }
  it { expect(subject).to_not be_all_documents_loaded }

  it do
    expect{ subject.done! }.to raise_error(Workflow::NoTransitionAllowed)
  end

  describe 'загруженные документы' do
    let(:aml_order_document) { subject.aml_order_documents.take }
    before do
      aml_order_document.update image: Rack::Test::UploadedFile.new(Rails.root.join('test_files', 'test.png'))
    end

    it { expect(subject).to be_all_documents_loaded }

    context 'отмечает как загруженный' do
      before do
        subject.done!
      end
      it { expect(subject).to be_pending }

      context 'обработка' do
        before do
          subject.process!
        end

        context 'приняли' do
          before { subject.accept! }

          it { expect(subject).to be_accepted }
        end


        context 'отклонили' do
          let(:reject_reason) { 'bad image' }
          before { subject.reject! reject_reason: reject_reason }
          it { expect(subject).to be_rejected }
          it { expect(subject.reject_reason).to eq reject_reason }
        end
      end
    end
  end
end
