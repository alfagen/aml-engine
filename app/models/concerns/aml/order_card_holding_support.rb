module AML
  module OrderCardHoldingSupport
    extend ActiveSupport::Concern

    def card_holding_start!
      update! card_holding_state: :start
    end

    def card_holding_failed!
      update! card_holding_state: :failed
    end

    # Удачно прошло холдирование, присоедияем карту
    # @param [String] bin - первые 4 цифры карты
    # @param [String] suffix - последние 4 цифры карты
    # @param [String] brand - брэнд карты (Visa/Master)
    def card_holding_success!(bin:, suffix:, brand: )
      update!(
        card_bin:       bin,
        card_suffix:    suffix,
        card_brand:     brand,
        card_holding_state:    :success,
        card_holding_state_updated_at: Time.zone.now
      )
    end
  end
end
