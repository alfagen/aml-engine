module AML
  class ClientInfo < ApplicationRecord
    include Authority::Abilities

    belongs_to :aml_client, class_name: 'AML::Client', foreign_key: :aml_client_id

    enum gender: { male: 'male', female: 'female' }
  end
end
