module AML
  class PaymentCardOrder < ApplicationRecord
    include Authority::Abilities
    include Workflow
    include OrdersWorkflow

    mount_uploader :image, PaymentCardOrderFileUploader

    belongs_to :client, class_name: 'AML::Client', foreign_key: :aml_client_id, inverse_of: :payment_card_orders, dependent: :destroy
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', foreign_key: :aml_reject_reason_id, optional: true
    belongs_to :operator, class_name: 'AML::Operator', foreign_key: :aml_operator_id, optional: true, inverse_of: :payment_card_orders

    has_one :aml_payment_card, class_name: 'AML::PaymentCard', inverse_of: :aml_accepted_order

    validates :card_brand, presence: true
    validates :card_bin, presence: true, length: { is: 6 }
    validates :card_suffix, presence: true, length: { is: 4 }

    ransacker :id do
      Arel.sql("CONVERT(#{table_name}.id, CHAR(8))")
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

    def accept
      touch :operated_at
      create_payment_card
    end


    def create_payment_card
      AML::PaymentCard.create!(brand: card_brand, bin: card_bin, suffix: card_suffix, aml_client_id: client.id, aml_payment_card_order_id: id)
    end

    def is_owner?(operator)
      self.operator == operator
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
