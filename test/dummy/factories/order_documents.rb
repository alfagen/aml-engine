FactoryBot.define do
  factory(:order_document, class: AML::OrderDocument) do
    image { Rack::Test::UploadedFile.new(Rails.root.join('test_files', 'test.png')) }
    order
    document_kind
  end
end
