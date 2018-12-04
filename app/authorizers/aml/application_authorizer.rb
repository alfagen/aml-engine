module AML
  class ApplicationAuthorizer < Authority::Authorizer
    # Any class method from Authority::Authorizer that isn't overridden
    # will call its authorizer's default method.
    #
    # @param [Symbol] adjective; example: `:creatable`
    # @param [Object] user - whatever represents the current user in your app
    # @return [Boolean]
    def self.default(_adjective, user)
      user.aml_operator.administrator?
    end
  end
end
