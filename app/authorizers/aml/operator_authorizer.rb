module AML
  class OperatorAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(user)
      user.aml_operator.administrator?
    end

    def updatable_by?(user)
      resource.user == user || user.aml_operator.administrator?
    end

    def blockable_by?(user)
      resource.user != user && user.aml_operator.administrator?
    end

    def unblockable_by?(user)
      blockable_by? user.aml_operator
    end
  end
end
