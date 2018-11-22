require_relative 'application_controller'

module AML
  class OrderChecksController < ApplicationController
    authorize_actions_for AML::OrderCheck

    helper_method :order

    def accept
      authorize_action_for order_check
      order_check.accept!
      flash.notice = "Чеклист '#{order_check.aml_check_list}' принят"
      redirect_back fallback_location: order_path(order)
    end

    def reject
      authorize_action_for order_check
      order_check.reject!
      flash.notice = "Чеклист '#{order_check.aml_check_list}' отклонен"
      redirect_back fallback_location: order_path(order)
    end

    private

    def order_check
      @order_check ||= order.order_checks.find params[:id]
    end

    def order
      @order ||= AML::Order.find params[:order_id]
    end
  end
end
