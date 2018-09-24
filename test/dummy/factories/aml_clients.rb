FactoryBot.define do
  factory(:aml_client, class: AML::Client) do
    first_name { 'Name' }
    aml_status
  end
end
