module AML
  class ClientDocumentFieldsController < AML::ApplicationController
    def edit
      render :edit, locals: { client_document_field: client_document_field,
                              client_document: client_document,
                              document_kind_field_definition: client_document_field.definition }
    end

    def update
      client_document_field.update!(permitted_params)
      redirect_to client_document_path(client_document)
    rescue ActiveRecord::RecordInvalid => error
      flash.now.alert = error.message
      render :edit, locals: error_params(error)
    end

    private

    def client_document_field
      @client_document_field ||= AML::ClientDocumentField.find params[:id]
    end

    def client_document
      @client_document ||= client_document_field.client_document
    end

    def permitted_params
      params.fetch(:aml_client_document_field, {}).permit(:value)
    end

    def error_params(error)
      { client_document_field: error.record,
        client_document: error.record.client_document,
        document_kind_field_definition: error.record.definition }
    end
  end
end
