module AML
  class Notification < ApplicationRecord
    include Authority::Abilities

    has_many :aml_notification_templates, class_name: 'AML::NotificationTemplate', foreign_key: :aml_notification_id, dependent: :destroy

    has_one :status_on_pending_notification, class_name: 'AML::Status', foreign_key: :on_pending_notification_id, dependent: :nullify
    has_one :status_on_accept_notification, class_name: 'AML::Status', foreign_key: :on_accept_notification_id, dependent: :nullify
    has_one :status_on_reject_notification, class_name: 'AML::Status', foreign_key: :on_reject_notification_id, dependent: :nullify
    has_one :status_on_card_pending_notification, class_name: 'AML::Status', foreign_key: :on_card_pending_notification_id, dependent: :nullify
    has_one :status_on_card_accept_notification, class_name: 'AML::Status', foreign_key: :on_card_accept_notification_id, dependent: :nullify
    has_one :status_on_card_reject_notification, class_name: 'AML::Status', foreign_key: :on_card_reject_notification_id, dependent: :nullify

    validates :title, presence: true, uniqueness: true

    after_create :create_templates

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
