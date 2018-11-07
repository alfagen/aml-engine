FactoryBot.define do
  factory(:aml_order_check, class: AML::OrderCheck) do
    aml_order
    aml_check_list
  end
end
