# frozen_string_literal: true

module AML
  class OperatorsController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { operator: paginate(AML::Operator.ordered) }
    end

    def new
      render :new, locals: { operator: AML::Operator.new(permitted_params) }
    end

    def create
      AML::Operator.create!(permitted_params)
      redirect_to operators_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { operator: e.record }
    end

    def edit
      render :edit, locals: { operator: operator }
    end

    def update
      operator.update!(permitted_params)
      redirect_to operators_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { operator: e.record }
    end

    def block
      operator.block!
      redirect_to operators_path, notice: "Пользователь, #{operator.email} был заблокирован"
    end

    def unblock
      operator.unblock!
      redirect_to operators_path, notice: "Пользователь, #{operator.email} был разблокирован"
    end

    private

    def operator
      @operator ||= AML::Operator.find params[:id]
    end

    def permitted_params
      params.fetch(:aml_operator, {}).permit(:email, :role, :password, :password_confirmation, :crypted_password, :salt, :workflow_state)
    end
  end
end
