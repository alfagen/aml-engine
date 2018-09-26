FactoryBot.define do
  factory(:aml_document_field, class: AML::DocumentField) do
    value { 'some' }
    aml_order_document
    association :aml_definition, factory: :aml_document_kind_field_definition
  end
end
