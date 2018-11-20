require_relative 'application_controller'

module AML
  class OrdersController < ApplicationController # rubocop:disable Metrics/ClassLength
    include Pagination

    authorize_actions_for AML::Order

    def index
      render :index, locals: {
        q: q,
        orders: paginate(q.result),
        workflow_state: workflow_state
      }
    end

    def new
      render :new, locals: { order: AML::Order.new(permitted_params) }
    end

    def create
      redirect_to order_path(AML::Order.create!(permitted_params))
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { order: e.record }
    end

    def show
      authorize_action_for order
      render :show, locals: { order: order, client_info: client_info }
    end

    def done
      authorize_action_for order
      order.done!
      flash.notice = 'Заявка отмечена как загруженная'
      redirect_to order_path(order)
    end

    def start
      authorize_action_for order
      order.start! operator: current_user
      flash.notice = 'Заявка принята в обработку'
      redirect_to order_path(order)
    end

    def accept
      authorize_action_for order
      order.accept!
      flash.notice = 'Заявка принята'

      redirect_to order_path(order)
    rescue Workflow::TransitionHalted => e
      flash.now.alert = e.message
      render :show, locals: { order: order }
    end

    def cancel
      authorize_action_for order
      order.cancel!
      flash.notice = 'Обработка заявки приостановлена'
      redirect_to order_path(order)
    end

    private

    DEFAULT_WORKFLOW_STATE = :pending

    def client_info
      return order.client.aml_client_info if order.client.aml_client_info.present?

      build_client_info
    end

    def build_client_info
      order
        .client
        .build_aml_client_info(
          first_name: order.first_name,
          last_name: order.surname,
          birth_date: order.birth_date,
          patronymic: order.patronymic,
          aml_client: order.client
        )
    end

    def workflow_state
      params[:workflow_state] || DEFAULT_WORKFLOW_STATE
    end

    def orders
      # Показываем все заявки, в не зависимости от того кто из взял
      AML::Order.where(workflow_state: workflow_state)
    end

    def order
      @order ||= AML::Order.find params[:id]
    end

    def permitted_params
      params
        .fetch(:order, {})
        .permit(:first_name, :surname, :patronymic, :birth_date, :client_id, :workflow_state, :aml_reject_reason_id, :reject_reason_details)
    end

    def q
      @q ||= build_query
    end

    def build_query
      query = orders.ransack params.fetch(:q, {}).permit!
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
