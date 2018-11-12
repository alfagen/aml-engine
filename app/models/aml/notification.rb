module AML
  class Notification < ApplicationRecord
    KEYS = %w(personal_order_received professional_order_received order_rejected personal_status_accepted professional_status_accepted)

    validates :locale, presence: true, inclusion: { in: I18n.available_locales.map(&:to_s) }
    validates :key, presence: true, uniqueness: { scope: :locale }, inclusion: { in: KEYS }

    def self.create_all!
      KEYS.each do |key|
        I18n.available_locales.each do |locale|
          find_or_create_by!(locale: locale, key: key)
        end
      end
    end
  end
end
