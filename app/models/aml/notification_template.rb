module AML
  class NotificationTemplate < ApplicationRecord
    include Authority::Abilities

    belongs_to :aml_notification, class_name: 'AML::Notification', foreign_key: :aml_notification_id

    validates :locale, presence: true, inclusion: { in: I18n.available_locales.map(&:to_s) }
  end
end
