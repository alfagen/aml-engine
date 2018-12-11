module AML
  class ApplicationAuthorizer < ::ApplicationAuthorizer
    # Any class method from Authority::Authorizer that isn't overridden
    # will call its authorizer's default method.
    #
    # @param [Symbol] adjective; example: `:creatable`
    # @param [Object] user - whatever represents the current user in your app
    # @return [Boolean]
    def self.default(_adjective, operator)
      operator.administrator?
    end
  end
end
