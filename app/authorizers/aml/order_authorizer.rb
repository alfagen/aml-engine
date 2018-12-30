module AML
  class OrderAuthorizer < ApplicationAuthorizer
    EVENTS = %i[done start accept reject cancel].freeze
    OWNER_REQUIRED_FOR_EVENTS = %i[accept reject cancel].freeze

    def self.readable_by?(user)
      user.aml_operator.present?
    end

    EVENTS.each do |event|
      ability = Authority.abilities[event] || raise("No ability for event #{event}")
      define_singleton_method "#{ability}_by?" do |user|
        user.aml_operator.present?
      end
    end

    EVENTS.each do |event|
      ability = Authority.abilities[event] || raise("No ability for event #{event}")
      define_method "#{ability}_by?" do |user|
        resource.enabled_workflow_events.include?(event) \
          && (OWNER_REQUIRED_FOR_EVENTS.exclude?(event) || user.aml_operator&.administrator? || resource.is_owner?(user.aml_operator))
      end
    end
  end
end
