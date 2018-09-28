require 'spec_helper'

RSpec.describe AML::Order, type: :model do
  let!(:aml_document_kind) { create :aml_document_kind }
  let(:aml_status) { create :aml_status, :default }
  let!(:aml_client) { create :aml_client, aml_status: aml_status }

  before do
    aml_status.aml_document_groups << aml_document_kind.document_group
  end

  subject { create :aml_order, aml_status_id: aml_status.id }

  let(:aml_order_document) { subject.order_documents.take }

  it { expect(subject).to be_persisted }
  it { expect(subject).to be_none }
  it { expect(subject.order_documents).to be_one }
  it { expect(subject).to_not be_all_documents_loaded }

  it do
    expect{ subject.done! }.to raise_error(Workflow::NoTransitionAllowed)
  end

  describe 'при создани изаявки она становится текущей' do
    let!(:client) { create :aml_client }

    context 'статус клиента обновляется если принятая заявка его увеличивает' do
      let!(:status2) { create :aml_status, position: aml_status.position + 1 }

      it { expect(client.current_order.aml_status).to eq aml_status }

      context 'создает еще одну заявку' do
        before do
          @order = create :aml_order, client: client, aml_status: status2
          @order.order_documents << aml_order_document
          client.reload
        end

        it 'новая заявка становится текущей' do
          expect(client.current_order).to eq @order
        end

        context 'заявку одобряют' do
          before do
            expect_any_instance_of(AML::Order).to receive(:all_documents_loaded?).and_return true
            @order.done!
            @order.process!
            aml_order_document.update image: Rack::Test::UploadedFile.new(Rails.root.join('test_files', 'test.png'))
            aml_order_document.accept!
            @order.accept!
          end

          it 'статус увеличивается если заявка принята' do
            expect(client.aml_status).to eq status2
          end
        end
      end
    end
  end

  describe 'загруженные документы' do
    before do
      aml_order_document.update image: Rack::Test::UploadedFile.new(Rails.root.join('test_files', 'test.png'))
    end

    it { expect(subject).to be_all_documents_loaded }

    context 'заказ без ФИО' do
      before do
        subject.update first_name: nil
      end
      it 'не дает отправить' do
        expect{ subject.done! }.to raise_error(Workflow::TransitionHalted)
      end
    end

    context 'отмечает как загруженный' do
      before do
        subject.done!
      end

      context do
        it { expect(subject).to be_pending }
      end

      context 'обработка' do
        before do
          subject.process!
        end

        it 'нельзя принять если документы не приняты' do
          expect{ subject.accept! }.to raise_error(Workflow::TransitionHalted)
        end

        context 'можно принять заявку если документы приняты' do
          before do
            subject.order_documents.take.accept!
            subject.accept!
          end

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
          