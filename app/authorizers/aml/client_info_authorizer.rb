module AML
  class ClientInfoAuthorizer < ApplicationAuthorizer
    def self.default(_adjective, _operator)
      true
    end
  end
end
