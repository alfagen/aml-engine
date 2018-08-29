# frozen_string_literal: true

module AML
  class ClientDocumentsController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { documents: documents, workflow_state: workflow_state }
    end

    def new
      render :new, locals: { client_document: AML::ClientDocument.new(permitted_params),
                             order: AML::Order.find(permitted_params[:order_id]),
                             document_kinds: document_kinds }
    end

    def create
      AML::ClientDocument.create!(permitted_params)
      redirect_back(fallback_location: client_documents_path)
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { client_document: e.record,
                             order: e.record.order,
                             document_kinds: document_kinds }
    end

    def show
      render :show, locals: { client_document: client_document,
                              fields: client_document.client_document_fields }
    end

    def accept
      client_document.accept!
      redirect_to client_document_path(client_document)
    end

    def reject
      client_document.reject!
      redirect_to client_document_path(client_document)
    end

    private

    DEFAULT_WORKFLOW_STATE = :pending

    def workflow_state
      params[:workflow_state] || DEFAULT_WORKFLOW_STATE
    end

    def documents
      paginate(AML::ClientDocument.where(workflow_state: workflow_state))
    end

    def client_document
      @client_document ||= AML::ClientDocument.find params[:id]
    end

    def document_kinds
      @document_kinds ||= AML::DocumentKind.all.ordered
    end

    def permitted_params
      params.fetch(:aml_client_document).permit(:document_kind_id, :image, :order_id, :workflow_state)
    end
  end
end
