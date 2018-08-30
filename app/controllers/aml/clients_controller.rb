# frozen_string_literal: true

module AML
  class ClientsController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { clients: paginate(q.result.ordered) }
    end

    def show
      add_breadcrumb 'Клиенты', :clients_path
      add_breadcrumb "Клиент #{client.id}"
      render :show, locals: { client: client, orders: client.orders.ordered }
    end

    def new
      add_breadcrumb 'Клиенты', :clients_path
      add_breadcrumb 'Добавляем нового клиента'
      render :new, locals: { client: AML::Client.new(permitted_params) }
    end

    def create
      AML::Client.create!(permitted_params)
      redirect_to clients_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { client: e.record }
    end

    private

    def q
      @q ||= AML::Client.ransack params.fetch(:q, {}).permit!
    end

    def client
      @client ||= AML::Client.find params[:id]
    end

    def permitted_params
      params.fetch(:aml_client, {}).permit(:first_name, :surname, :patronymic, :birth_date, :workflow_state)
    end
  end
end
