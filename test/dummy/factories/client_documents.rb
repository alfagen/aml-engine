FactoryBot.define do
  factory(:client_document, class: AML::ClientDocument) do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
    workflow_state { 'pending' }
    order
    document_kind
  end
end
