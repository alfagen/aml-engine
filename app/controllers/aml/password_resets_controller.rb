module AML
  class PasswordResetsController < AML::ApplicationController
    layout 'simple'

    before_action :require_login, only: [:update]

    def create
      operator = AML::Operator.find_by email: params.require(:password_reset).fetch(:email)
      operator&.deliver_reset_password_instructions!
    end

    def edit
      operator = AML::Operator.load_from_reset_password_token(params[:id])

      if operator.present?
        auto_login operator
        render 'aml/passwords/edit', locals: { operator: operator }
      else
        flash.now.alert = 'Просрочен токен аутентификации, авторизуйтесь снова'
        render 'new'
      end
    end

    def update
      current_user.password_confirmation = params[:operator][:password_confirmation]
      current_user.change_password! params[:operator][:password]
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render 'aml/passwords/edit', locals: { operator: e.record }
    end
  end
end
