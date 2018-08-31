FactoryBot.define do
  factory(:document_kind, class: AML::DocumentKind) do
    sequence(:title) { |n| "title#{n}" }
  end
end
