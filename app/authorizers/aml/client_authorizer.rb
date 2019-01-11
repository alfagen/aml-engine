module AML
  class ClientAuthorizer < ApplicationAuthorizer
    def self.updatable_by?(user)
      user.aml_operator.present?
    end

    def updatable_by?(user)
      user.aml_operator.present?
    end

    def self.readable_by?(user)
      user.aml_operator.present?
    end

    def readable_by?(user)
      user.aml_operator.present?
    end

    def resetable_by?(user)
      user.aml_operator.present?
    end
  end
end
