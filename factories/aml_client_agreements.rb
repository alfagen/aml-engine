FactoryBot.define do
  factory :aml_client_agreement, class: AML::ClientAgreement do
    aml_client
    aml_agreement
    remote_ip { '127.0.0.1' }
    user_agent { 'user_agent' }
    locale { 'ru' }
  end
end
