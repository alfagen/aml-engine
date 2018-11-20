# frozen_string_literal: true

module AML
  class OrderDocumentsController < ApplicationController
    include Pagination

    authorize_actions_for AML::OrderDocument

    def index
      render :index, locals: { documents: paginate(documents), workflow_state: workflow_state }
    end

    def edit
      authorize_action_for order_document
      render :edit, locals: { order_document: order_document }
    end

    def update
      authorize_action_for order_document
      order_document.update!(permitted_params)
      redirect_to order_document_path(order_document)
    rescue ActiveRecord::RecordInvalid, AML::OrderDocument::ClosedOrderError => e
      flash.now.alert = e.message
      render :edit, locals: { order_document: order_document }
    end

    def show
      authorize_action_for order_document
      render :show, locals: { order_document: order_document }
    end

    def accept
      authorize_action_for order_document
      order_document.accept!
      redirect_to order_path(order)
    end

    private

    DEFAULT_WORKFLOW_STATE = :none

    delegate :order, to: :order_document

    def workflow_state
      params[:workflow_state] || DEFAULT_WORKFLOW_STATE
    end

    def documents
      AML::OrderDocument.where(workflow_state: workflow_state)
    end

    def order_document
      @order_document ||= AML::OrderDocument.find params[:id]
    end

    def permitted_params
      params.fetch(:order_document, {}).permit(:document_kind_id, :image, :order_id, :workflow_state)
    end
  end
end
