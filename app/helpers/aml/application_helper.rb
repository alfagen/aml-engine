# frozen_string_literal: true

module AML
  module ApplicationHelper
    def aml_order_active_type(workflow_state)
      workflow_state == :none ? :inclusive : :exact
    end

    DEFAULT_TYPE = :warning
    TYPES = { alert: :error, notice: :info }.freeze

    def aml_noty_flash_javascript(key, message)
      noty_type = TYPES[key.to_sym] || DEFAULT_TYPE

      "window.Flash.show(#{noty_type.to_json}, #{message.to_json})"
    end
  end
end
