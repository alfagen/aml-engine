require_relative 'application_decorator'

module AML
  class PaymentCardOrderDecorator < ApplicationDecorator
    delegate_all

    def id
      h.link_to object.id, h.order_path(object)
    end

    def client_name
      h.link_to object.client_name, h.client_path(object.aml_client_id)
    end

    def reject_reason
      return unless object.aml_reject_reason.present?

      buffer = []
      buffer << object.aml_reject_reason.title
      buffer << h.content_tag(:div, object.reject_reason_details) if object.reject_reason_details.present?

      h.content_tag :div, buffer.join.html_safe, class: 'alert alert-info'
    end

    def pending_at
      h.humanized_time_in_current_time_zone object.pending_at
    end

    def operated_at
      h.humanized_time_in_current_time_zone object.operated_at
    end

    def created_at
      h.humanized_time_in_current_time_zone object.created_at
    end

    def operator
      object.operator&.name
    end

    def client
      h.link_to object.client, h.client_path(object.client)
    end

    def accepted_at
      return object.operated_at if object.accepted?
    end

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: 'time' do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end
  end
end
