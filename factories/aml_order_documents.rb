FactoryBot.define do
  factory(:aml_order_document, class: AML::OrderDocument) do
    aml_order
    aml_document_kind
  end
end
