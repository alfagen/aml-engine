class AML::ClientSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_client

  belongs_to :aml_current_order, record_type: :aml_order, serializer: 'AML::OrderSerializer'
  belongs_to :aml_status, record_type: :aml_status, serializer: 'AML::StatusSerializer'

  attributes :workflow_state, :aml_status_id
end
