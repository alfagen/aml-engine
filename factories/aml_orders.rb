FactoryBot.define do
  factory(:aml_order, class: AML::Order) do
    first_name { 'First name' }
    surname { 'Surname' }
    patronymic { 'patronymic' }
    birth_date { Time.zone.today - 30.years }
    association :client, factory: :aml_client
    aml_status

    AML::Order.workflow_spec.states.keys.each do |state|
      trait state do
        workflow_state { state.to_s }
      end
    end
  end
end
