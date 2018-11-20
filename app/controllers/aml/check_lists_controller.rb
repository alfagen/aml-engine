# frozen_string_literal: true

require_relative 'application_controller'

module AML
  class CheckListsController < ApplicationController
    include Pagination

    authorize_actions_for AML::CheckList

    def index
      render :index, locals: { check_lists: AML::CheckList.alive.ordered }
    end

    def new
      render :new, locals: { check_list: AML::CheckList.new(permitted_params) }
    end

    def edit
      render :edit, locals: { check_list: check_list }
    end

    def create
      AML::CheckList.create!(permitted_params)

      redirect_to check_lists_path, notice: 'Создан новый список проверки'
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { check_list: e.record }
    end

    def update
      check_list.update! permitted_params

      redirect_to check_lists_path, notice: 'Список проверки обновлен'
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { check_list: e.record }
    end

    def show
      redirect_to edit_check_list_path(check_list)
    end

    def destroy
      check_list.destroy!
      flash.now.notice = 'Чек-лист удален'
      redirect_to check_lists_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      redirect_back fallback_location: check_lists_path
    end

    private

    def check_list
      @check_list ||= AML::CheckList.find params[:id]
    end

    def permitted_params
      params.fetch(:check_list, {}).permit!
    end
  end
end
