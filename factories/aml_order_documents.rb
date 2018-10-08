FactoryBot.define do
  factory(:aml_order_document, class: AML::OrderDocument) do
    association :order, factory: :aml_order
    association :document_kind, factory: :aml_document_kind

    trait :loaded do
      image { Rack::Test::UploadedFile.new(Rails.root.join('test_files', 'test.png')) }
    end
  end
end
