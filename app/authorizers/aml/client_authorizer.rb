module AML
  class ClientAuthorizer < ApplicationAuthorizer
    def self.updatable_by?(user)
      true
    end

    def updatable_by?(user)
      true
    end

    def self.readable_by?(user)
      true
    end

    def readable_by?(user)
      true
    end

    def resetable_by?(user)
      updatable_by? user&.aml_operator
    end
  end
end
