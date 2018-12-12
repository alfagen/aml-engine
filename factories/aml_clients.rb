FactoryBot.define do
  factory(:aml_client, class: AML::Client) do

    trait :with_risk do
      risk_category { 'A' }
    end
  end
end
