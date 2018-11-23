# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class ClientsController < ApplicationController
    helper OrdersHelper
    authorize_actions_for AML::Client

    def index
      render :index, locals: { clients: paginate(q.result.ordered) }
    end

    def update
      authorize_action_for client
      client.update! params.require(:client).permit(:risk_category)

      flash.notice = "Клиенту #{client} установлена категория риска #{client.risk_category}"
      redirect_back fallback_location: client_path(client)
    end

    def show
      authorize_action_for client
      add_breadcrumb 'Клиенты', :clients_path
      add_breadcrumb "Клиент #{client.id}"
      query = client.orders.ransack(params.fetch(:q, {}).permit!)
      render :show, locals: { client: client, orders: query.result, q: query, client_info: client_info }
    end

    def reset
      authorize_action_for client
      client.reset_status!
      redirect_back_or_to client_path(client), notice: "Статус клиента сброшен до '#{client.aml_status.try(:title)}'"
    end

    def new
      add_breadcrumb 'Клиенты', :clients_path
      add_breadcrumb 'Добавляем нового клиента'
      render :new, locals: { client: AML::Client.new(permitted_params) }
    end

    def create
      client = AML::Client.new permitted_params
      authorize_action_for client
      client.save!

      flash.notice = "Создан клиент ##{client.id}"
      redirect_to client_path(client)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { client: e.record }
    end

    private

    def client_info
      client.aml_client_info || client.build_aml_client_info
    end

    def q
      @q ||= AML::Client.ransack params.fetch(:q, {}).permit!
    end

    def client
      @client ||= AML::Client.find params[:id]
    end

    def permitted_params
      params.fetch(:client, {}).permit(:first_name, :surname, :patronymic, :birth_date, :email, :phone, :aml_status_id)
    end
  end
end
