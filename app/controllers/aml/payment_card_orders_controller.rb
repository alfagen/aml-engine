# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class PaymentCardOrdersController < ApplicationController
    authorize_actions_for AML::PaymentCardOrder

    def index
      render :index, locals: { q: q, payment_card_orders: paginate(q.result), workflow_state: workflow_state }
    end

    def new
      render :new, locals: { payment_card_order: AML::PaymentCardOrder.new(permitted_params) }
    end

    def create
      redirect_to payment_card_order_path(AML::PaymentCardOrder.create!(permitted_params))
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { payment_card_order: e.record }
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

    def start
      authorize_action_for payment_card_order
      payment_card_order.start! operator: current_user
      flash.notice = 'Заявка принята в обработку'
      redirect_to payment_card_order_path(payment_card_order)
    end

    def accept
      authorize_action_for payment_card_order
      payment_card_order.accept!
      flash.notice = 'Заявка принята'

      redirect_to payment_card_order_path(payment_card_order)
    rescue Workflow::TransitionHalted => e
      flash.now.alert = e.message
      render :show, locals: { payment_card_order: payment_card_order }
    end

    def cancel
      authorize_action_for payment_card_order
      payment_card_order.cancel!
      flash.notice = 'Обработка заявки приостановлена'
      redirect_to payment_card_order_path(payment_card_order)
    end

    private

    DEFAULT_WORKFLOW_STATE = :pending

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

    def q
      @q ||= build_query
    end

    def build_query
      query = payment_card_orders.ransack params.fetch(:q, {}).permit!
      if query.sorts.empty?
        query.sorts = get_session_sorts workflow_state
      else
        set_session_sorts workflow_state, params[:q][:s]
      end
      query
    end

    def set_session_sorts(workflow_state, sorts)
      session[workflow_state.to_s + '_sorts'] = sorts
    end

    def get_session_sorts(workflow_state)
      if workflow_state == 'pending'
        session[workflow_state.to_s + '_sorts'] || 'pending_at asc'
      elsif workflow_state == 'none'
        session[workflow_state.to_s + '_sorts'] || 'updated_at asc'
      else
        session[workflow_state.to_s + '_sorts'] || 'operated_at asc'
      end
    end
  end
end
