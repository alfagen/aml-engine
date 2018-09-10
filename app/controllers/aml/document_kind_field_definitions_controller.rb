module AML
  class DocumentKindFieldDefinitionsController < AML::ApplicationController
    def new
      render :new, locals: { document_kind_field_definition: AML::DocumentKindFieldDefinition.new(permitted_params) }
    end

    def create
      AML::DocumentKindFieldDefinition.create!(permitted_params)
      redirect_to document_kind_path(document_kind)
    rescue ActiveRecord::RecordInvalid => e
      redirect_to document_kind, alert: e.message
    end

    def edit
      render :edit, locals: { document_kind_field_definition: document_kind_field_definition }
    end

    def update
      document_kind_field_definition.update!(permitted_params)
      redirect_to document_kind_path(permitted_params[:document_kind_id])
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { document_kind_field_definition: e.record }
    end

    def restore
      document_kind_field_definition.restore!
      redirect_to document_kind_path(document_kind_field_definition.document_kind)
    end

    def archive
      document_kind_field_definition.archive!
      redirect_to document_kind_path(document_kind_field_definition.document_kind)
    end

    private

    def document_kind_field_definition
      @document_kind_field_definition ||= AML::DocumentKindFieldDefinition.find params[:id]
    end

    def document_kind
      @document_kind ||= AML::DocumentKind.find permitted_params[:document_kind_id]
    end

    def permitted_params
      params.fetch(:document_kind_field_definition, {}).permit(:key, :title, :document_kind_id)
    end
  end
end
