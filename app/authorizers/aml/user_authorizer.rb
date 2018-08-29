module AML
  class UserAuthorizer < ApplicationAuthorizer
    def self.creatable_by?(user)
      user.administrator?
    end

    def role_updatable_by?(user)
      resource != user && user.administrator?
    end

    def updatable_by?(user)
      (resource == user && user.operator?) || user.administrator?
    end

    def blockable_by?(user)
      user.administrator?
    end
  end
end
