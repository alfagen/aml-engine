# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class PaymentCardOrdersController < ApplicationController
    authorize_actions_for AML::PaymentCardOrder

    def index
      render :index, locals: { payment_card_orders: paginate(payment_card_orders), workflow_state: workflow_state }
    end

    def new
      render :new, locals: { payment_card_order: AML::PaymentCardOrder.new(permitted_params) }
    end

    def create
      redirect_to payment_card_order_path(AML::PaymentCardOrder.create!(permitted_params))
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { order: e.record }
    end

    def edit
      authorize_action_for payment_card_order
      render :edit, locals: { payment_card_order: payment_card_order }
    end

    def update
      authorize_action_for payment_card_order
      payment_card_order.update!(permitted_params)
      redirect_to payment_card_order_path(payment_card_order)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { payment_card_order: payment_card_order }
    end

    def show
      authorize_action_for payment_card_order
      render :show, locals: { payment_card_order: payment_card_order }
    end

    def accept
      authorize_action_for payment_card_order
      payment_card_order.accept!
      redirect_to payment_card_order_path(payment_card_order)
    end

    private

    DEFAULT_WORKFLOW_STATE = :loaded

    def workflow_state
      params[:workflow_state] || DEFAULT_WORKFLOW_STATE
    end

    def payment_card_orders
      AML::PaymentCardOrder.where(workflow_state: workflow_state)
    end

    def payment_card_order
      @payment_card_order ||= AML::PaymentCardOrder.find params[:id]
    end

    def permitted_params
      params.fetch(:payment_card_order, {}).permit(:card_brand, :card_bin, :card_suffix, :image, :aml_client_id, :workflow_state)
    end
  end
end
