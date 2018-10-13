class UserMailer < ApplicationMailer
  def reset_password_email(user)
    mail(to: user.email)
  end
end
