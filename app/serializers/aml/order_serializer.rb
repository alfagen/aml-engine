module AML
  class OrderSerializer
    include FastJsonapi::ObjectSerializer

    set_type :aml_order

    has_many :order_documents, record_type: :aml_order_document

    attributes :first_name, :surname, :patronymic, :workflow_state, :birth_date
  end
end
