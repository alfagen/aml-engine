module AML
  module OrdersNotifications
    extend ActiveSupport::Concern

    def notification_locale
      client.notification_locale || I18n.default_locale
    end

    def notify(notification_key)
      AML::NotificationMailer.logger.warn "Try to notify order[#{id}] with #{notification_key}"

      notification = client.aml_status&.send notification_key
      unless notification
        AML::NotificationMailer.logger.warn "No #{notification_key} notification for status #{client.aml_status}"
        return
      end

      notification_template = notification.
        aml_notification_templates.
        find_by(locale: notification_locale)

      unless notification_template.present? && notification_template.template_id.present?
        AML::NotificationMailer.logger.warn "No template_id for #{notification} and #{notification_locale}"
        return
      end

      client.notify notification_template.template_id,
        first_name: (first_name.presence || client.first_name),
        reject_reason_title: aml_reject_reason.try(:title),
        reject_reason_details: reject_reason_details.presence
    end
  end
end
