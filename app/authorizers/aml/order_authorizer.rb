module AML
  class OrderAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(operator)
      operator.administrator? || operator.operator?
    end

    def self.processable_by?(operator)
      operator.administrator? || operator.operator?
    end

    def taken_by?(operator)
      resource.current_state >= :processing && resource.operator_id == operator.id
    end

    def self.readable_by?(operator)
      operator.administrator? || operator.operator?
    end
  end
end
