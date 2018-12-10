module AML
  class PaymentCardOrder < ApplicationRecord
    include Authority::Abilities
    include Workflow

    mount_uploader :image, PaymentCardOrderFileUploader

    belongs_to :client, class_name: 'AML::Client', foreign_key: :aml_client_id, inverse_of: :payment_card_orders, dependent: :destroy
    belongs_to :aml_reject_reason, class_name: 'AML::RejectReason', foreign_key: :aml_reject_reason_id, optional: true

    validates :card_brand, presence: true
    validates :card_bin, presence: true
    validates :card_suffix, presence: true

    workflow do
      state :none do
        event :load, transitions_to: :loaded
      end

      state :loaded do
        event :accept, transitions_to: :accepted
        event :reject, transitions_to: :rejected
      end

      state :accepted do
        event :reject, transitions_to: :rejected
      end

      state :rejected do
        event :accept, transitions_to: :accepted
      end
    end

    def reject(reject_reason:, details: nil)
      halt! 'Причина должна быть указана' unless reject_reason.is_a? AML::RejectReason
      update aml_reject_reason: reject_reason, reject_reason_details: details
    end

    def client_name
      ["##{client.id}", client.first_name, client.surname, client.patronymic].compact.join ' '
    end
  end
end
