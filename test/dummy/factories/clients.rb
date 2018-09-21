FactoryBot.define do
  factory(:client, class: AML::Client) do
    first_name { 'Name' }
    association :aml_status, factory: :status
  end
end
