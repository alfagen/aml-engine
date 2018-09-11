FactoryBot.define do
  factory(:order_document, class: AML::OrderDocument) do
    order
    document_kind
  end
end
