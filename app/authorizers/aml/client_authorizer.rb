module AML
  class ClientAuthorizer < ApplicationAuthorizer
    def self.updatable_by?(user)
      user.aml_operator
    end

    def updatable_by?(user)
      user.aml_operator
    end

    def self.readable_by?(user)
      user.aml_operator
    end

    def readable_by?(user)
      user.aml_operator
    end

    def resetable_by?(user)
      updatable_by? user
    end
  end
end
