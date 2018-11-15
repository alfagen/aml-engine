module AML
  class ClientInfo < ApplicationRecord
    extend Enumerize

    belongs_to :aml_client, class_name: 'AML::Client', foreign_key: :aml_client_id

    enumerize :gender, in: %w(male female)
  end
end
