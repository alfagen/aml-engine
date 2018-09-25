FactoryBot.define do
  factory(:aml_document_field, class: AML::DocumentField) do
    value { 'some' }
    association :order_document, factory: :aml_order_document
    association :definition, factory: :aml_document_kind_field_definition
  end
end
