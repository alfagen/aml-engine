module AML
  class OrderSerializer
    include FastJsonapi::ObjectSerializer

    set_type :aml_order

    has_many :order_documents, record_type: :aml_order_document
    belongs_to :aml_status, record_type: :aml_status, serializer: 'AML::StatusSerializer'
    belongs_to :aml_reject_reason, record_type: :aml_status, serializer: 'AML::RejectReasonSerializer'

    attributes :first_name, :surname, :patronymic, :workflow_state, :reject_reason_details, :birth_date, :created_at, :updated_at

    attribute :reject_reason do |o|
      [o.aml_reject_reason.title, o.reject_reason_details].compact.join('. ') if o.rejected?
    end

    attribute :is_locked do |o|
      o.is_locked?
    end
  end
end
