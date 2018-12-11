module AML
  module OrdersWorkflow
    extend ActiveSupport::Concern

    included do
      workflow_column :workflow_state

      workflow do
        state :none do
          event :done, transitions_to: :pending, if: :allow_done?
          event :cancel, transitions_to: :canceled
        end

        # Пользователь загрузил, ждет когда оператор начнет обрабатывать
        state :pending do
          on_entry do
            notify :on_pending_notification
          end
          event :start, transitions_to: :processing
          event :cancel, transitions_to: :canceled
        end

         # Оператор начал обрабатывать
        state :processing do
          event :accept, transitions_to: :accepted, if: :allow_accept?
          event :reject, transitions_to: :rejected
          event :cancel, transitions_to: :pending
        end

        state :accepted do
          # TODO сомнительно что можно так делать
          event :reject, transitions_to: :rejected
          on_entry do
            notify :on_accept_notification
          end
        end

        # Отклонена оператором
        state :rejected do
          on_entry do
            notify :on_reject_notification
          end
        end

        # Отменена пользователем (или автоматом при создании новой)
        state :canceled
      end

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
end
