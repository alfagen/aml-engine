module AML
  class PaymentCardOrderAuthorizer < ApplicationAuthorizer
    def self.readable_by?(_user)
      true
    end

    def acceptable_by?(operator)
      operator.administrator?&& resource.can_accept?
    end

    def rejectable_by?(operator)
      operator.administrator? && resource.can_reject?
    end
  end
end
