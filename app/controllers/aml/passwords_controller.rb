module AML
  class PasswordsController < AML::ApplicationController
    def edit
      render :edit, locals: { user: current_user }
    end

    def update
      current_user.update!(permitted_params)
      redirect_to users_path
    rescue ActiveRecord::RecordInvalid => e
      flash.now.alert = e.message
      render :edit, locals: { user: e.record }
    end

    private

    def permitted_params
      params.require(:aml_user).permit(:email, :password, :password_confirmation)
    end
  end
end
