module AML
  class OrderAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(user)
      user.administrator? || user.operator?
    end

    def self.processable_by?(user)
      user.administrator? || user.operator?
    end

    def taken_by?(user)
      resource.current_state >= :processing && resource.user_id == user.id
    end

    def self.readable_by?(user)
      user.administrator? || user.operator?
    end
  end
end
