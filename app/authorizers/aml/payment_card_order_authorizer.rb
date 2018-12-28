module AML
  class PaymentCardOrderAuthorizer < OrderAuthorizer
    def updatable_by?(user)
      resource.none? && user&.aml_operator&.administrator?
    end
  end
end
