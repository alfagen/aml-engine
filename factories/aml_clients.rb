FactoryBot.define do
  factory(:aml_client, class: AML::Client) do
    sequence(:email) { |n| "email#{n}@example.com" }
  end
end
