FactoryBot.define do
  factory(:aml_document_kind, class: AML::DocumentKind) do
    sequence(:title) { |n| "title#{n}" }

    association :document_group, factory: :aml_document_group

    trait :with_definitions do
      after(:create) do |instance|
        create :aml_document_kind_field_definition, document_kind: instance
        create :aml_document_kind_field_definition, document_kind: instance
      end
    end

    trait :with_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
      file_title { 'file_title' }
    end
  end
end
