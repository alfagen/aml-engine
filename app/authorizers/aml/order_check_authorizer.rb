module AML
  class OrderCheckAuthorizer < ApplicationAuthorizer
    EVENTS = %i[accept reject].freeze
    def self.readable_by?(user)
      user.aml_operator
    end

    def self.acceptable_by?(user)
      user.aml_operator
    end

    def self.rejectable_by?(user)
      user.aml_operator
    end

    def acceptable_by?(user)
      (user.aml_operator&.administrator? || user.aml_operator == resource.aml_order.operator) && resource.can_accept?
    end

    def rejectable_by?(user)
      (user.aml_operator&.administrator? || user.aml_operator == resource.aml_order.operator) && resource.can_reject?
    end
  end
end
