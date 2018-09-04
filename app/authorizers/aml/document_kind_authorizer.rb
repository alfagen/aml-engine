module AML
  class DocumentKindAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(operator)
      operator.administrator? || operator.operator?
    end

    def self.readable_by?(operator)
      operator.administrator? || operator.operator?
    end
  end
end
