module AML
  class Notification < ApplicationRecord
    has_many :aml_notification_templates, class_name: 'AML::NotificationTemplate', foreign_key: :aml_notification_id
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
