FactoryBot.define do
  sequence(:title) { |n| "title#{n}" }
  sequence(:key) { |n| "key#{n}" }
  factory(:status, class: AML::Status) do
    title { generate :title }
    key { generate :key }
  end
end
