module AML
  class NotificationMailer < ApplicationMailer
    def notify(email:, template_id:, data: {})
      mail(
        to:          email,
        template_id: template_id,

        # TODO фиасануть в gem-е
        # lib/sendgrid_actionmailer.rb
        #
        # убрать json_parse
        #  84   | | | | p.add_dynamic_template_data(json_parse(mail['dynamic_template_data'].value))
        #
        dynamic_template_data:  data.to_json,
        # Чтобы sendgrid принял нужно хоть что-то передавать,
        # а если ничего не передавать, то запускается render
        body: 'dummy'
        # mail_settings: mail_settings(aml_client)
      )
    end

    private

    def mail_settings(_aml_client)
      if Rails.env.production? ||
          (!Rails.env.test? && defined?(Secrets) && Secrets.aml_allowed_emails.include?(aml_client.email))
        {}
      else
        { sandbox_mode: { enable: true } }
      end
    end
  end
end
