module AML
  module OrderNotifications
    extend ActiveSupport::Concern

    private

    def notify(notification_key)
      AML.logger.warn "Try to notify order[#{id}] with #{notification_key}"

      notification = find_notification_for_key notification_key
      unless notification
        Bugsnag.notify "No notification key" do |b|
          b.severity = :warning
          b.meta_data = { notification_key: notification_key, record: self }
        end if defined? Bugsnag
        AML.logger.warn "No #{notification_key} notification for #{self.class}##{id}"
        return
      end

      notification_template = notification.
        aml_notification_templates.
        find_by(locale: notification_locale)

      unless notification_template.present? && notification_template.template_id.present?
        AML.logger.warn "No template_id for #{notification} and #{notification_locale}"
        return
      end

      AML.logger.info "Sending notification #{notification_key} with template_id #{notification_template.template_id} for client #{client.id} (#{client.email})"
      client.notify notification_template.template_id,
        first_name: client_first_name,
        reject_reason_title: aml_reject_reason.try(:title),
        reject_reason_details: reject_reason_details.presence
    end

    def client_first_name
      read_attribute(:first_name).presence || client.first_name
    end

    def notification_locale
      client.notification_locale || I18n.default_locale
    end
  end
end
