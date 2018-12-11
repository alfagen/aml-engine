require_relative 'application_controller'

module AML
  class PaymentCardOrderRejectionsController < ApplicationController
    authorize_actions_for :payment_card_order, all_actions: :reject

    helper_method :payment_card_order

    def new
      render :new, locals: { payment_card_order: payment_card_order, reasons: available_reject_reasons }
    end

    def create
      authorize_action_for payment_card_order
      payment_card_order.reject! reject_reason: find_reject_reason, details: permitted_params[:reject_reason_details]
      flash.notice = 'Заявка отклонена'
      redirect_to payment_card_order_path(payment_card_order)
    rescue Workflow::TransitionHalted => e
      flash.now.alert = e.message
      render :new, locals: { payment_card_order: payment_card_order }
    end

    private

    def payment_card_order
      @payment_card_order ||= AML::PaymentCardOrder.find params[:payment_card_order_id]
    end

    def find_reject_reason
      id = permitted_params[:aml_reject_reason_id]
      AML::RejectReason.find_by(id: id) || raise("Не найдена причина отклонения #{id}")
    end

    def available_reject_reasons
      AML::RejectReason.card_order_reason.ordered.alive.map do |rr|
        [rr.title, rr.id]
      end
    end

    def permitted_params
      params.require(:payment_card_order).permit(:aml_reject_reason_id, :reject_reason_details)
    end
  end
end
