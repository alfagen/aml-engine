module AML
  class PaymentCardOrderAuthorizer < ApplicationAuthorizer
    EVENTS = %i[done start accept reject cancel].freeze

    def self.readable_by?(user)
      user.administrator?
    end

    EVENTS.each do |event|
      ability = Authority.abilities[event] || raise("No ability for event #{event}")
      define_singleton_method "#{ability}_by?" do |_operator|
        true
      end
    end

    EVENTS.each do |event|
      ability = Authority.abilities[event] || raise("No ability for event #{event}")
      define_method "#{ability}_by?" do |operator|
        resource.enabled_workflow_events.include?(event) && operator.administrator?
      end
    end
  end
end
