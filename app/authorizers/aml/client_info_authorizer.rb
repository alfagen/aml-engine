module AML
  class ClientInfoAuthorizer < ApplicationAuthorizer
    def self.default(_adjective, user)
      user.aml_operator
    end
  end
end
