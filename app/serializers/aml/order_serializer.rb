module AML
  class OrderSerializer
    include FastJsonapi::ObjectSerializer

    set_type :aml_order

    has_many :order_documents, record_type: :aml_order_document
    belongs_to :aml_status, record_type: :aml_status, serializer: 'AML::StatusSerializer'

    attributes :first_name, :surname, :patronymic, :workflow_state, :birth_date, :created_at, :updated_at

    attribute :is_locked do |o|
      o.is_locked?
    end
  end
end
