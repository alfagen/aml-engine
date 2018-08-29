module AML
  class DocumentKindAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(user)
      user.administrator? || user.operator?
    end

    def self.readable_by?(user)
      user.administrator? || user.operator?
    end
  end
end
