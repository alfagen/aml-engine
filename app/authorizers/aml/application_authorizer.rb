module AML
  class ApplicationAuthorizer < ::ApplicationAuthorizer
    # Any class method from Authority::Authorizer that isn't overridden
    # will call its authorizer's default method.
    #
    # @param [Symbol] adjective; example: `:creatable`
    # @param [Object] user - whatever represents the current user in your app
    # @return [Boolean]
    def self.default(_adjective, user)
      user.aml_operator&.administrator?
    end

    def readable_by?(user)
      user.aml_operator.present?
    end

    def updatable_by?(user)
      readable_by? user
    end

    def creatable_by?(user)
      readable_by? user
    end

    def deletable_by?(user)
      readable_by? user
    end
  end
end
