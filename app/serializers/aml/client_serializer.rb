class AML::ClientSerializer
  include FastJsonapi::ObjectSerializer

  set_type :aml_client

  belongs_to :current_order, record_type: :aml_order, serializer: 'AML::OrderSerializer'

  attributes :workflow_state
end
