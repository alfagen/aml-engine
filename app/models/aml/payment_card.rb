module AML
  class PaymentCard < ApplicationRecord
    scope :ordered, -> { order :id }

    validates :brand, presence: true
    validates :bin, presence: true
    validates :suffix, presence: true

    belongs_to :accepted_order, class_name: 'AML::Order', foreign_key: :aml_order_id, inverse_of: :aml_payment_card
    belongs_to :client, class_name: 'AML::Client', foreign_key: :aml_client_id, inverse_of: :payment_card_orders, dependent: :destroy

    def masked_number
         # NOTE dup нужен, т.к. insert изменяет исходный объект
         "#{bin.dup.insert(4, ' ')}** **** #{last_digits} #{brand} "
    end
  end
end
