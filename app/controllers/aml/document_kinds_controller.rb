# frozen_string_literal: true

module AML
  class DocumentKindsController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { document_kinds: paginate(AML::DocumentKind.ordered) }
    end

    def new
      render :new, locals: { document_kind: AML::DocumentKind.new(permitted_params) }
    end

    def create
      AML::DocumentKind.create!(permitted_params)
      redirect_to document_kinds_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { document_kind: e.record }
    end

    def show
      render :show, locals: { document_kind: document_kind,
                              field_definitions: document_kind.document_kind_field_definitions }
    end

    private

    def document_kind
      @document_kind ||= AML::DocumentKind.find params[:id]
    end

    def permitted_params
      params.fetch(:aml_document_kind, {}).permit(:title)
    end
  end
end
