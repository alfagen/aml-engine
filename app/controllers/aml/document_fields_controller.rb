require_relative 'application_controller'

module AML
  class DocumentFieldsController < ApplicationController
    authorize_actions_for :order_document, all_actions: :update

    def edit
      render :edit, locals: { document_field: document_field,
                              order_document: order_document,
                              document_kind_field_definition: document_field.definition }
    end

    def update
      document_field.update!(permitted_params)
      redirect_to order_document_path(order_document)
    rescue ActiveRecord::RecordInvalid, AML::DocumentField::ClosedOrderError => e
      flash.now.alert = e.message
      render :edit, locals: { document_field: document_field,
                              order_document: order_document,
                              document_kind_field_definition: document_field.definition }
    end

    private

    def document_field
      @document_field ||= AML::DocumentField.find params[:id]
    end

    def order_document
      @order_document ||= document_field.order_document
    end

    def permitted_params
      params.fetch(:document_field, {}).permit(:value)
    end
  end
end
