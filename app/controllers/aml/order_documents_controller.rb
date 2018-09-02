# frozen_string_literal: true

module AML
  class OrderDocumentsController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { documents: documents, workflow_state: workflow_state }
    end

    def new
      render :new, locals: { order_document: AML::OrderDocument.new(permitted_params),
                             order: AML::Order.find(permitted_params[:order_id]),
                             document_kinds: document_kinds }
    end

    def create
      AML::OrderDocument.create!(permitted_params)
      redirect_back(fallback_location: order_documents_path)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { order_document: e.record,
                             order: e.record.order,
                             document_kinds: document_kinds }
    end

    def show
      render :show, locals: { order_document: order_document,
                              fields: order_document.client_document_fields }
    end

    def accept
      order_document.accept!
      redirect_to order_document_path(order_document)
    end

    def reject
      order_document.reject!
      redirect_to order_document_path(order_document)
    end

    private

    DEFAULT_WORKFLOW_STATE = :pending

    def workflow_state
      params[:workflow_state] || DEFAULT_WORKFLOW_STATE
    end

    def documents
      paginate(AML::OrderDocument.where(workflow_state: workflow_state))
    end

    def order_document
      @order_document ||= AML::OrderDocument.find params[:id]
    end

    def document_kinds
      @document_kinds ||= AML::DocumentKind.all.ordered
    end

    def permitted_params
      params.fetch(:aml_order_document).permit(:document_kind_id, :image, :order_id, :workflow_state)
    end
  end
end
