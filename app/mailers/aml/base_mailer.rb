module AML
  class BaseMailer < ApplicationMailer
    default from: 'from@example.com'
    layout 'mailer'
  end
end
