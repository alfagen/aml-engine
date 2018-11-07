FactoryBot.define do
  sequence(:aml_check_list_title) { |n| "title#{n}" }

  factory(:aml_check_list, class: AML::CheckList) do
    title { generate :aml_check_list_title }
  end
end
