require_relative 'application_controller'

module AML
  class OrderRejectionsController < ApplicationController
    def new
      authorize_action_for order
      render :new, locals: { order: order, reasons: available_reject_reasons }
    end

    def create
      authorize_action_for order
      order.reject! reject_reason: find_reject_reason, details: permitted_params[:reject_reason_details]
      flash.notice = 'Заявка отклонена'
      redirect_to order_path(order)
    rescue Workflow::TransitionHalted => e
      flash.now.alert = e.message
      render :new, locals: { order: order }
    end

    private

    def order
      @order ||= AML::Order.find params[:order_id]
    end

    def find_reject_reason
      id = permitted_params[:aml_reject_reason_id]
      AML::RejectReason.find_by(id: id) || raise("Не найдена причина отклонения #{id}")
    end

    def available_reject_reasons
      AML::RejectReason.order_reason.ordered.alive.map do |rr|
        [rr.title, rr.id]
      end
    end

    def permitted_params
      params.require(:order).permit(:aml_reject_reason_id, :reject_reason_details)
    end
  end
end
