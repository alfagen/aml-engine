# frozen_string_literal: true

module AML
  module ApplicationHelper
    def aml_order_active_type(workflow_state)
      workflow_state == :none ? :inclusive : :exact
    end

    def aml_document_active_type(workflow_state)
      workflow_state == :pending ? :inclusive : :exact
    end
  end
end
