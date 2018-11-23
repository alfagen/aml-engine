module AML
  module OrdersHelper
    ORDER_WORKFLOW_STATE_CLASSES = {
      'none' => 'label-default',
      'pending' => 'label-warning',
      'processing' => 'label-warning',
      'accepted' => 'label-success',
      'rejected' => 'label-danger'
    }.freeze

    ORDER_CHECK_WORKFLOW_STATE_CLASSES = {
      'none' => 'label-default',
      'accepted' => 'label-success',
      'rejected' => 'label-danger'
    }.freeze

    def order_workflow_state(workflow_state)
      workflow_state = workflow_state.workflow_state if workflow_state.is_a? AML::Order

      classes = [:label]
      classes << ORDER_WORKFLOW_STATE_CLASSES[workflow_state]
      content_tag :span, workflow_state, class: classes
    end

    def order_check_workflow_state(workflow_state)
      workflow_state = workflow_state.workflow_state if workflow_state.is_a? AML::OrderCheck

      classes = [:label]
      classes << ORDER_CHECK_WORKFLOW_STATE_CLASSES[workflow_state]
      content_tag :span, workflow_state, class: classes
    end

    def order_card(order)
      return '-' unless order.card_brand.present?

      "#{order.card_bin}..#{order.card_suffix} #{order.card_brand}"
    end
  end
end
