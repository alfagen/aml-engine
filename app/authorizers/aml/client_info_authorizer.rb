module AML
  class ClientInfoAuthorizer < ApplicationAuthorizer
    def self.default(_adjective, user)
      true
    end
  end
end
