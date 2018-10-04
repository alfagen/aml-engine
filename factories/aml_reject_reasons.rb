FactoryBot.define do
  factory(:aml_reject_reason, class: AML::RejectReason) do
    sequence(:title) { |n| "title#{n}" }
  end
end
