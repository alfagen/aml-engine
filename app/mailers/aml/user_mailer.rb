module AML
  class UserMailer < AML::BaseMailer
    def reset_password_email(operator)
      @url = edit_password_reset_url(operator.reset_password_token)
      mail(to: operator.email, subject: 'Вы зарегистрированы')
    end
  end
end
