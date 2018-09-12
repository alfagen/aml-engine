FactoryBot.define do
  factory(:client, class: AML::Client) do
    first_name { 'Name' }
  end
end
