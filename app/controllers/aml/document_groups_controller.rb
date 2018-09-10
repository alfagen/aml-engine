# frozen_string_literal: true

module AML
  class DocumentGroupsController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { document_groups: paginate(AML::DocumentGroup.ordered) }
    end

    def new
      render :new, locals: { document_group: AML::DocumentGroup.new(permitted_params) }
    end

    def create
      AML::DocumentGroup.create!(permitted_params)
      redirect_to document_groups_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { document_group: e.record }
    end

    def show
      render :show, locals: { document_group: document_group }
    end

    private

    def document_group
      @document_group ||= AML::DocumentGroup.find params[:id]
    end

    def permitted_params
      params.fetch(:document_group, {}).permit(:title, :details, :position)
    end
  end
end
