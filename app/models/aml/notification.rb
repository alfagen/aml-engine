module AML
  class Notification < ApplicationRecord
    extend Enumerize
    include Authority::Abilities

    has_many :aml_notification_templates, class_name: 'AML::NotificationTemplate', foreign_key: :aml_notification_id, dependent: :destroy

    validates :title, presence: true, uniqueness: true
    validates :key, uniqueness: true, allow_blank: true

    after_create :create_templates

    enumerize :key, in: %w(payment_card_pending payment_card_accepted payment_card_rejected)

    def to_s
      title
    end

    private

    def create_templates
      I18n.available_locales.each do |locale|
        aml_notification_templates.find_or_create_by!(locale: locale)
      end
    end
  end
end
