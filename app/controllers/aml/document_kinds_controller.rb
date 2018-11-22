# frozen_string_literal: true
require_relative 'application_controller'

module AML
  class DocumentKindsController < ApplicationController
    authorize_actions_for AML::DocumentKind

    helper_method :document_group

    def index
      redirect_to document_group_path(document_group)
    end

    def new
      render :new, locals: { document_kind: AML::DocumentKind.new(permitted_params) }
    end

    def create
      document_group.document_kinds.create!(permitted_params)
      redirect_to document_group_path(document_group)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { document_kind: e.record }
    end

    def edit
      render :edit, locals: { document_kind: document_kind }
    end

    def update
      document_kind.update!(permitted_params)
      redirect_to document_group_path(document_group)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { document_kind: e.record }
    end

    def destroy
      document_kind.destroy!
      flash.now.notice = 'Вид документа удален'
      redirect_to document_group_path(document_kind.document_group_id)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      redirect_back fallback_location: document_group_path(document_kind.document_group_id)
    end

    def show
      redirect_to edit_document_group_document_kind_path(document_group, document_kind)
    end

    private

    def document_kind
      @document_kind ||= AML::DocumentKind.find params[:id]
    end

    def document_group
      @document_group ||= AML::DocumentGroup.find params[:document_group_id]
    end

    def permitted_params
      params.fetch(:document_kind, {}).permit!
    end
  end
end
