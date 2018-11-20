module AML
  class ClientInfoAuthorizer < ApplicationAuthorizer
    def self.updatable_by?(_operator)
      true
    end

    def updatable_by?(_operator)
      true
    end

    def self.readable_by?(_operator)
      true
    end

    def readable_by?(_operator)
      true
    end

    def resetable_by?(operator)
      updatable_by? operator
    end
  end
end
