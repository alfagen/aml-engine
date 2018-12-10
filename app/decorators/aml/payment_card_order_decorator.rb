require_relative 'application_decorator'

module AML
  class PaymentCardOrderDecorator < ApplicationDecorator
    delegate_all

    def reject_reason
      return unless object.aml_reject_reason.present?

      buffer = []
      buffer << object.aml_reject_reason.title
      buffer << h.content_tag(:div, object.reject_reason_details) if object.reject_reason_details.present?

      h.content_tag :div, buffer.join.html_safe, class: 'alert alert-info'
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
