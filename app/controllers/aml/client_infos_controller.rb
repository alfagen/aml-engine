# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class ClientInfosController < ApplicationController
    include Pagination

    COLUMNS = %i[
      first_name maiden_name last_name
      patronymic birth_date birth_place gender
      address citizenship passport_number
      second_document_number card_suffix
      utility_bill
    ].freeze

    authorize_actions_for AML::ClientInfo

    def index
      render :index, locals: {
        client_infos: paginate(AML::ClientInfo.order(:first_name)),
        columns: COLUMNS
      }, layout: 'wide'
    end

    def new
      render :new, locals: { client_info: AML::ClientInfo.new(permitted_params) }
    end

    def edit
      render :edit, locals: { client_info: client_info }
    end

    def create
      AML::ClientInfo.create!(permitted_params)

      redirect_back fallback_location: client_infos_path, notice: 'Информация добавления'
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { client_info: e.record }
    end

    def update
      client_info.update! permitted_params

      redirect_back fallback_location: client_infos_path, notice: 'Информация добавления'
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { client_info: e.record }
    end

    def show
      redirect_to edit_client_info_path client_info
    end

    private

    def client_info
      @client_info ||= AML::ClientInfo.find params[:id]
    end

    def permitted_params
      params.fetch(:client_info, {}).permit!
    end
  end
end
