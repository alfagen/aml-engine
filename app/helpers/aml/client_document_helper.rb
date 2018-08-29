# frozen_string_literal: true

# Стиль active для первоначального открытия на вкладке pending
#
module AML
  module ClientDocumentHelper
    def document_active_type(workflow_state)
      workflow_state == :pending ? :inclusive : :exact
    end
  end
end
