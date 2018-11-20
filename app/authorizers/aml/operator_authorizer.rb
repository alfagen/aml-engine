module AML
  class OperatorAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(operator)
      operator.administrator?
    end

    def role_updatable_by?(operator)
      resource != operator && operator.administrator?
    end

    def updatable_by?(operator)
      resource == operator || operator.administrator?
    end

    def blockable_by?(operator = nil)
      resource != operator && operator.administrator?
    end

    def unblockable_by?(operator)
      blockable_by? operator
    end
  end
end
