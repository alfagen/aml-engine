require 'spec_helper'

RSpec.describe AML::NotificationMailer do
  let!(:aml_document_kind) { create :aml_document_kind }
  let!(:pending_notification) { create :aml_notification, title: 'pending' }
  let!(:aml_status) { create :aml_status, :default, on_pending_notification_id: pending_notification.id }
  let!(:aml_client) {
    create :aml_client,
    aml_status: aml_status,
    email: 'mail@mail.com',
    risk_category: AML::Client.risk_category.values.first
  }
  let(:aml_order) { create :aml_order, aml_status_id: aml_status.id, client_id: aml_client.id }
  let!(:operator) { create :aml_operator }

  before do
    aml_status.aml_document_groups << aml_document_kind.document_group
  end

  let(:aml_order_document) { aml_order.order_documents.take }

  describe 'загруженные документы' do
    before do
      aml_order_document.update image: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png'))
    end

    context do
      it 'если нет template_id то done! не отправляет уведомление по order' do
        expect{aml_order.done!}.to_not change{ActionMailer::Base.deliveries.count}
      end
    end

    context do
      it 'если есть template_id то done! отправляет уведомление по order' do
        pending_notification.aml_notification_templates.update template_id: 'template_id'
        expect{aml_order.done!}.to change{ActionMailer::Base.deliveries.count}
        expect(ActionMailer::Base.deliveries.last.to).to eq ['mail@mail.com']
      end
    end
  end
end
