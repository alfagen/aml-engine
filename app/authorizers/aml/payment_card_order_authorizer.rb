module AML
  class PaymentCardOrderAuthorizer < OrderAuthorizer
    def updatable_by?(operator)
      resource.none? && operator.administrator?
    end
  end
end
