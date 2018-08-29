# frozen_string_literal: true

module AML
  class UsersController < AML::ApplicationController
    include Pagination

    def index
      render :index, locals: { users: paginate(AML::User.ordered) }
    end

    def new
      render :new, locals: { user: AML::User.new(permitted_params) }
    end

    def create
      AML::User.create!(permitted_params)
      redirect_to users_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :new, locals: { user: e.record }
    end

    def edit
      render :edit, locals: { user: user }
    end

    def update
      user.update!(permitted_params)
      redirect_to users_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { user: e.record }
    end

    def block
      user.block!
      redirect_to users_path, notice: "Пользователь, #{user.email} был заблокирован"
    end

    def unblock
      user.unblock!
      redirect_to users_path, notice: "Пользователь, #{user.email} был разблокирован"
    end

    private

    def user
      @user ||= AML::User.find params[:id]
    end

    def permitted_params
      params.fetch(:aml_user, {}).permit(:email, :role, :password, :password_confirmation, :crypted_password, :salt, :workflow_state)
    end
  end
end
