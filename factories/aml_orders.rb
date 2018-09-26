FactoryBot.define do
  factory(:aml_order, class: AML::Order) do
    first_name { 'First name' }
    surname { 'Surname' }
    patronymic { 'patronymic' }
    birth_date { Time.zone.today - 30.years }
    aml_client
    aml_status

    trait :processing do
      workflow_state { 'processing' }
    end
  end
end
