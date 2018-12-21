# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class NotificationsController < ApplicationController
    authorize_actions_for AML::Notification

    def new
      render :new, locals: { notification: AML::Notification.new(permitted_params) }
    end

    def edit
      render :edit, locals: { notification: notification }
    end

    def create
      AML::Notification.create!(permitted_params)

      redirect_to notifications_path, notice: 'Создано новое уведомление'
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { notification: e.record }
    end

    def update
      notification.update permitted_params

      respond_to do |format|
        format.html { redirect_to notifications_path }
        format.json { respond_with_bip notification }
      end
    end

    def destroy
      notification.destroy!

      flash.notice = 'Удален'
    rescue ActiveRecord::RecordInvalid => e
      flash.alert = e.message
    ensure
      redirect_back_or_to notifications_path
    end

    private

    def notification
      @notification ||= AML::Notification.find params[:id]
    end

    def permitted_params
      params.fetch(:notification, {}).permit!
    end
  end
end
