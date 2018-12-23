FactoryBot.define do
  factory(:aml_client, class: AML::Client) do
    sequence(:email) { |n| "email#{n}@mail.com" }
  end
end
