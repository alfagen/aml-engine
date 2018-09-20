FactoryBot.define do
  sequence(:title) { |n| "title#{n}" }
  factory(:status, class: AML::Status) do
    title { generate :title }
  end
end
