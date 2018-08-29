module AML
  class ClientAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(user)
      user.administrator? || user.operator?
    end

    def self.processable_by?(user)
      user.administrator? || user.operator?
    end

    def self.readable_by?(user)
      user.administrator? || user.operator?
    end
  end
end
