module AML
  class PaymentCardOrder < ApplicationRecord
    include Authority::Abilities
    include Workflow

    include OrderWorkflow
    include OrderNotifications
    include CardValidation

    CARD_BRANDS = %w(visa master mir).freeze

    mount_uploader :image, OrderDocumentFileUploader

    belongs_to :client, class_name: 'AML::Client', foreign_key: :aml_client_id, inverse_of: :payment_card_orders, dependent: :destroy
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', foreign_key: :aml_reject_reason_id, optional: true
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: :aml_operator_id, optional: true, inverse_of: :payment_card_orders

    has_one :aml_payment_card, class_name: 'AML::PaymentCard', inverse_of: :aml_accepted_order, foreign_key: :aml_payment_card_order_id

    validates :card_brand, inclusion: { in: CARD_BRANDS, message: "Валидны: #{CARD_BRANDS.join(', ')}." }
    validates :card_bin, card_bin: { card_brand_attribute: :card_brand }
    validates :card_suffix, card_suffix: { card_brand_attribute: :card_brand }

    ransacker :id do
      Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
    end

    def load!(_arg)
      done!
    end

    def allow_done?
      image.present?
    end

    def allow_accept?
      allow_done?
    end

    def accepted_at
      return operated_at if accepted?
    end

    def accept
      touch :operated_at
      client.aml_payment_cards.create!(
        card_brand:    card_brand,
        card_bin:      card_bin,
        card_suffix:   card_suffix,
        aml_client_id: client.id,
        aml_payment_card_order_id: id
      )
    rescue Mysql2::Error, ActiveRecord::RecordNotUnique => err
      Bugsnag.notify err if defined? Bugsnag
      AML.logger.warn "#{err} when creating payment_card for payment_card_order_id=#{id}"
    end

    def is_owner?(operator)
      self.operator == operator
    end

    def done
      touch :pending_at
    end

    def client_name
      ["##{client.id}", client.first_name, client.surname, client.patronymic].compact.join ' '
    end

    private

    def find_notification_for_key(notification_key)
      AML::Notification.find_by(key: notification_key.to_s)
    end
  end
end
