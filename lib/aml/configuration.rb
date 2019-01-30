module AML
  module Configuration
    # Start a AML configuration block in an initializer.
    #
    # example: Provide a default currency for the application
    #   AML.configure do |config|
    #     config.default_currency = :eur
    #   end
    def configure
      yield self
    end

    # @param [Array] список email-ов на которые разрешается отправлять емайлы в НЕ production окружении
    mattr_accessor :allowed_emails
    @@allowed_emails = []

    # @param [Symbol] Валюта для кросс-расчетов по-умолчанию
    mattr_accessor :mail_from
    mattr_accessor :logger

    mattr_accessor :new_order_sendgrid_template_id

    # Валютя в которую сбрасываются значения счетчиков
    mattr_accessor :currency


    def currency
      @@currency ||= Money.default_currency
    end

    def logger
      @@logger || Rails.logger
    end
  end
end
