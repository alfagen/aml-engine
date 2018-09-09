FactoryBot.define do
  factory(:document_group, class: AML::DocumentGroup) do
    sequence(:title) { |n| "title#{n}" }
  end
end
