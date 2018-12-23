require 'spec_helper'

RSpec.describe AML::NotificationMailer do
  let(:pending_notification) { create :aml_notification, key: 'on_pending_notification' }
  let(:aml_status) { create :aml_status, :default, on_pending_notification: pending_notification }
  let(:aml_client) {
    create :aml_client,
    aml_status: aml_status,
    risk_category: AML::Client.risk_category.values.first
  }
  let(:aml_order) { create :aml_order, aml_status: aml_status, client: aml_client }
  let!(:aml_order_document) { create :aml_order_document, :loaded, order: aml_order }

  describe 'загруженные документы' do
    context do
      it 'если нет template_id то done! не отправляет уведомление по order' do
        expect{aml_order.done!}.to_not change{ActionMailer::Base.deliveries.count}
      end

      it 'если есть template_id то done! отправляет уведомление по order' do
        template = pending_notification.aml_notification_templates
        expect(template).to receive(:update).with(template_id: 'template_id').and_call_original
        template.update template_id: 'template_id'
        expect{aml_order.done!}.to change{ActionMailer::Base.deliveries.count}
        expect(ActionMailer::Base.deliveries.last.to).to eq [aml_client.email]
      end
    end
  end
end
