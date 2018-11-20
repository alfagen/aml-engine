# frozen_string_literal: true

require_relative 'application_controller'

module AML
  class DocumentGroupToStatusesController < ApplicationController
    authorize_actions_for :status, all_actions: :update

    def create
      AML::DocumentGroupToStatus.create!(permitted_params)
      redirect_to status_path(status)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { aml_document_group_to_status: e.record }
    end

    def destroy
      AML::DocumentGroupToStatus.find_by(permitted_params).destroy!
      redirect_to status_path(status)
    end

    private

    def document_group
      @document_group ||= AML::DocumentGroup.find permitted_params[:aml_document_group_id]
    end

    def status
      @status ||= AML::Status.find permitted_params[:aml_status_id]
    end

    def permitted_params
      params.fetch(:aml_document_group_to_status, {}).permit(:aml_status_id, :aml_document_group_id)
    end
  end
end
