# frozen_string_literal: true

module AML
  class RejectReasonsController < ApplicationController
    authorize_actions_for AML::RejectReason

    AVAILABLE_KINDS = AML::RejectReason.kinds.keys
    DEFAULT_KIND = AVAILABLE_KINDS.first

    helper_method :current_kind

    def index
      render :index, locals: { reject_reasons: AML::RejectReason.where(kind: current_kind).ordered }
    end

    def new
      render :new, locals: { reject_reason: AML::RejectReason.new(permitted_params) }
    end

    def create
      reject_reason = AML::RejectReason.create!(permitted_params)
      flash.notice = "Создана причина ##{reject_reason.id}"
      redirect_to success_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { reject_reason: e.record }
    end

    def edit
      render :edit, locals: { reject_reason: reject_reason }
    end

    def update
      reject_reason.update!(permitted_params)
      flash.notice = 'Причина изменена'
      redirect_to reject_reasons_path(reject_reason: { kind: reject_reason.kind })
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { reject_reason: e.record }
    end

    def destroy
      reject_reason.destroy!
      flash.notice = 'Причина удалена'
      redirect_to reject_reasons_path(reject_reason: { kind: reject_reason.kind })
    end

    private

    def success_path
      reject_reasons_path(reject_reason: { kind: current_kind })
    end

    def reject_reason
      @reject_reason ||= AML::RejectReason.find params[:id]
    end

    def current_kind
      k = params[:kind]
      return k if AVAILABLE_KINDS.include? k

      DEFAULT_KIND
    end

    def permitted_params
      params.require(:reject_reason).permit!
    end
  end
end
