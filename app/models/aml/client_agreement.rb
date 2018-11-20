module AML
  class ClientAgreement < ApplicationRecord
    include Authority::Abilities

    belongs_to :aml_client, class_name: 'AML::Client'
    belongs_to :aml_agreement, class_name: 'AML::Agreement'

    validates :aml_agreement_id, presence: true, uniqueness: { scope: :aml_client_id }
  end
end
