module AML
  module PaymentCardOrdersHelper
    PAYMENT_CARD_ORDER_WORKFLOW_STATE_CLASSES = {
      'none' => 'label-default',
      'pending' => 'label-warning',
      'processing' => 'label-warning',
      'accepted' => 'label-success',
      'rejected' => 'label-danger'
    }.freeze

    def payment_card_order_workflow_state(workflow_state)
      workflow_state = workflow_state.workflow_state if workflow_state.is_a? AML::Order

      classes = [:label]
      classes << PAYMENT_CARD_ORDER_WORKFLOW_STATE_CLASSES[workflow_state]
      content_tag :span, workflow_state, class: classes
    end

    def payment_card_order_card(payment_card_order)
      "#{payment_card_order.card_bin}..#{payment_card_order.card_suffix} #{payment_card_order.card_brand}"
    end
  end
end
