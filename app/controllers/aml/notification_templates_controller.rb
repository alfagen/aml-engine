# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class NotificationTemplatesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :handle_error

    authorize_actions_for AML::NotificationTemplate

    def update
      notification_template.update! permitted_params

      respond_to do |format|
        format.html { redirect_to notifications_path, notice: 'Уведомление изменено' }
        format.json { respond_with_bip notification_template }
      end
    end

    private

    def handle_error(exception)
      respond_to do |format|
        format.html do
          flash.now.alert = exception.message
          render :edit, locals: { notification_template: exception.record }
        end
        format.json { respond_with_bip notification_template }
      end
      redirect_to notifications_path, notice: 'Уведомление изменено'
    end

    def notification_template
      @notification_template ||= AML::NotificationTemplate.find params[:id]
    end

    def permitted_params
      params.fetch(:notification_template, {}).permit!
    end
  end
end
