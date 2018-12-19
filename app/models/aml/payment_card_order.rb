module AML
  class PaymentCardOrder < ApplicationRecord
    include Authority::Abilities
    include Workflow
    include PaymentCardOrdersNotifications
    include OrdersWorkflow
    include CardValidation

    mount_uploader :image, OrderDocumentFileUploader

    belongs_to :client, class_name: 'AML::Client', foreign_key: :aml_client_id, inverse_of: :payment_card_orders, dependent: :destroy
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', foreign_key: :aml_reject_reason_id, optional: true
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: :aml_operator_id, optional: true, inverse_of: :payment_card_orders

    has_one :aml_payment_card, class_name: 'AML::PaymentCard', inverse_of: :aml_accepted_order, foreign_key: :aml_payment_card_order_id

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
        card_brand: card_brand,
        card_bin: card_bin,
        card_suffix: card_suffix,
        aml_client_id: client.id,
        aml_payment_card_order_id: id
      )
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
  end
end
