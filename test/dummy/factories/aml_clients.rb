FactoryBot.define do
  factory(:aml_client, class: AML::Client) do
    first_name { 'Name' }
  end
end
