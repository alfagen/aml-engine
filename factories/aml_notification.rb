FactoryBot.define do
  sequence(:aml_notification_title) { |n| "title#{n}" }
  factory(:aml_notification, class: AML::Notification) do
    title { generate :aml_notification_title }
  end
end
