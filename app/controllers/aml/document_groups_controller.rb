# frozen_string_literal: true

module AML
  class DocumentGroupsController < ApplicationController
    include Pagination

    authorize_actions_for AML::DocumentGroup

    def index
      render :index, locals: { document_groups: AML::DocumentGroup.ordered }
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

    def edit
      render :edit, locals: { document_group: document_group }
    end

    def update
      document_group.update!(permitted_params)
      redirect_to document_groups_path
    rescue ActiveRecord::RecordInvalid => error
      flash.now.alert = error.message
      render :edit, locals: error_params(error)
    end

    def show
      render :show, locals: { document_group: document_group }
    end

    private

    def document_group
      @document_group ||= AML::DocumentGroup.find params[:id]
    end

    def permitted_params
      params.fetch(:document_group, {}).permit!
    end
  end
end
