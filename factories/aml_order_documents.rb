FactoryBot.define do
  factory(:aml_order_document, class: AML::OrderDocument) do
    association :document_kind, factory: :aml_document_kind
    association :order, factory: :aml_order

    trait :none do
      workflow_state { :none }
      image { nil }
    end

    trait :loaded do
      workflow_state { :loaded }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
    end

    trait :accepted do
      workflow_state { :accepted }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
    end

    trait :rejected do
      workflow_state { :loaded }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'test_files', 'test.png')) }
      after :create do |document|
        document.reject!
      end
    end
  end
end
