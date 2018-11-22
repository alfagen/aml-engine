# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class StatusesController < ApplicationController
    authorize_actions_for AML::Status

    def index
      render :index, locals: { statuses: AML::Status.alive.ordered }
    end

    def new
      render :new, locals: { status: AML::Status.new(permitted_params) }
    end

    def edit
      render :edit, locals: { status: status }
    end

    def create
      AML::Status.create!(permitted_params)

      redirect_to statuses_path, notice: 'Создан новый статус'
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { status: e.record }
    end

    def update
      status.update! permitted_params

      redirect_to statuses_path, notice: 'Статус обновлен'
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { status: e.record }
    end

    def show
      render :show, locals: { status: status }
    end

    private

    def status
      @status ||= AML::Status.find params[:id]
    end

    def permitted_params
      params.fetch(:status, {}).permit!
    end
  end
end
