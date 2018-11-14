module AML
  class ClientInfo < ApplicationRecord
    belongs_to :aml_client, class_name: 'AML::Client', foreign_key: :aml_client_id
  end
end
