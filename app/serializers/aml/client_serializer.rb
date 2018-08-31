class AML::ClientSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_client

  belongs_to :current_order, record_type: :aml_order
  # attributes :first_name, :surname, :patronymic, :birth_date

  attributes :workflow_state
end
