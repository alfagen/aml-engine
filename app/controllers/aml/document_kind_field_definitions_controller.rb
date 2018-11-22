require_relative 'application_controller'

module AML
  class DocumentKindFieldDefinitionsController < ApplicationController
    authorize_actions_for :document_kind, all_actions: :update

    helper_method :document_kind

    def new
      render :new, locals: { document_kind_field_definition: AML::DocumentKindFieldDefinition.new(permitted_params) }
    end

    def create
      document_kind.definitions.create! permitted_params

      flash.notice = 'Добавлено определение'

      redirect_to document_group_document_kind_path(document_kind.document_group, document_kind)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { document_kind_field_definition: e.record }
    end

    def edit
      render :edit, locals: { document_kind_field_definition: document_kind_field_definition }
    end

    def show
      redirect_to edit_document_group_document_kind_document_kind_field_definition_path params[:id]
    end

    def update
      document_kind_field_definition.update!(permitted_params)
      redirect_to edit_document_group_document_kind_document_kind_field_definition_path params[:id]
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { document_kind_field_definition: e.record }
    end

    def restore
      document_kind_field_definition.restore!
      redirect_to document_group_document_kind_path(document_kind.document_group, document_kind)
    end

    def archive
      document_kind_field_definition.archive!
      redirect_to document_group_document_kind_path(document_kind.document_group, document_kind)
    end

    private

    def document_kind_field_definition
      @document_kind_field_definition ||= AML::DocumentKindFieldDefinition.find params[:id]
    end

    def document_kind
      @document_kind ||= AML::DocumentKind.find params[:document_kind_id]
    end

    def permitted_params
      params.fetch(:document_kind_field_definition, {}).permit!
    end
  end
end
