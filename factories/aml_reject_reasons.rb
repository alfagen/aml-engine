FactoryBot.define do
  factory(:aml_reject_reason, class: AML::RejectReason) do
    sequence(:details) { |n| "details#{n}" }
  end
end
