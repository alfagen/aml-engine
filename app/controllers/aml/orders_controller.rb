module AML
  class OrdersController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { orders: paginate(q.result.ordered), workflow_state: workflow_state }
    end

    def new
      render :new, locals: { order: AML::Order.new(permitted_params), client: AML::Client.find(permitted_params[:client_id]) }
    end

    def create
      order = AML::Order.create! permitted_params
      redirect_to order_path(order)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { order: e.record, client_id: e.record.client.id }
    end

    def show
      render :show, locals: { order: order, client: order.client, document_kinds: document_kinds,
                              documents: paginate(order.order_documents.ordered) }
    end

    def in_process
      order.process!
      order.update(operator_id: current_user.id)
      redirect_to order_path(order)
    end

    def accept
      order.accept!
      redirect_to order_path(order)
    end

    def reject
      order.reject!
      redirect_to order_path(order)
    end

    def stop
      order.stop!
      order.update(operator_id: nil)
      redirect_to order_path(order)
    end

    private

    DEFAULT_WORKFLOW_STATE = :none

    def workflow_state
      params[:workflow_state] || DEFAULT_WORKFLOW_STATE
    end

    def orders
      AML::Order.where(workflow_state: workflow_state)
    end

    def order
      @order ||= AML::Order.find params[:id]
    end

    def document_kinds
      @document_kinds = AML::DocumentKind.all.ordered
    end

    def permitted_params
      params.fetch(:aml_order, {}).permit(:first_name, :surname, :patronymic, :birth_date, :client_id, :workflow_state)
    end

    def q
      @q ||= orders.ransack params.fetch(:q, {}).permit!
    end
  end
end
