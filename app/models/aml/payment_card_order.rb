module AML
  class PaymentCardOrder < ApplicationRecord
    include Authority::Abilities
    include Workflow

    mount_uploader :image, PaymentCardOrderFileUploader

    belongs_to :client, class_name: 'AML::Client', foreign_key: :aml_client_id, inverse_of: :payment_card_orders, dependent: :destroy
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', foreign_key: :aml_reject_reason_id, optional: true
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: :aml_operator_id, optional: true, inverse_of: :payment_card_orders

    validates :card_brand, presence: true
    validates :card_bin, presence: true
    validates :card_suffix, presence: true

    ransacker :id do
      Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
    end

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

    def allow_done?
      image.present?
    end

    def allow_accept?
      allow_done?
    end

    def reject(reject_reason:, details: nil)
      halt! 'Причина должна быть указана' unless reject_reason.is_a? AML::RejectReason
      update aml_reject_reason: reject_reason, reject_reason_details: details
      touch :operated_at
    end

    def accepted_at
      return operated_at if accepted?
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

    def accept
      touch :operated_at
    end


    def start(operator:)
      update operator: operator
    end

    def cancel
      update operator: nil
      touch :operated_at
    end

    def done
      touch :pending_at
    end

    def client_name
      ["##{client.id}", client.first_name, client.surname, client.patronymic].compact.join ' '
    end
  end
end
