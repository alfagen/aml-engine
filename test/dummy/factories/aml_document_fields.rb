FactoryBot.define do
  factory(:aml_document_field, class: AML::DocumentField) do
    value { 'some' }
  end
end
