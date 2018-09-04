module AML
  class OrderDocumentAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(operator)
      operator.administrator? || operator.operator?
    end

    def self.processable_by?(operator)
      operator.administrator? || operator.operator?
    end

    def self.readable_by?(operator)
      operator.administrator? || operator.operator?
    end
  end
end
