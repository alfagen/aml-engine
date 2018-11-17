# frozen_string_literal: true

module AML
  class ApplicationMailer < ActionMailer::Base
    default from: Settings.mailer.from

    # советуют ловить только ActiveJob::DeserializationError
    # но мне интересно что там вообще может падать
    rescue_from StandardError do |exception|
      Rails.logger.error exception
      Bugsnag.notify exception
      raise exception
    end
  end
end
