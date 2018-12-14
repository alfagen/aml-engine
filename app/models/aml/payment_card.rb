module AML
  class PaymentCard < ApplicationRecord
    include Authority::Abilities
    include CardValidation

    scope :ordered, -> { order :id }

    belongs_to :aml_accepted_order, class_name: 'AML::PaymentCardOrder', foreign_key: :aml_payment_card_order_id, inverse_of: :aml_payment_card
    belongs_to :aml_client, class_name: 'AML::Client', foreign_key: :aml_client_id, inverse_of: :aml_payment_cards

    def masked_number
      # NOTE dup нужен, т.к. insert изменяет исходный объект
      "#{card_bin} **** #{card_suffix} #{card_brand} "
    end
  end
end
