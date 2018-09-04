module AML
  class ClientDocumentFieldsController < AML::ApplicationController
    def edit
      render :edit, locals: { client_document_field: client_document_field,
                              order_document: order_document,
                              document_kind_field_definition: client_document_field.definition }
    end

    def update
      client_document_field.update!(permitted_params)
      redirect_to order_document_path(order_document)
    rescue ActiveRecord::RecordInvalid => error
      flash.now.alert = error.message
      render :edit, locals: error_params(error)
    end

    private

    def client_document_field
      @client_document_field ||= AML::ClientDocumentField.find params[:id]
    end

    def order_document
      @order_document ||= client_document_field.order_document
    end

    def permitted_params
      params.fetch(:aml_client_document_field, {}).permit(:value)
    end

    def error_params(error)
      { client_document_field: error.record,
        order_document: error.record.order_document,
        document_kind_field_definition: error.record.definition }
    end
  end
end
