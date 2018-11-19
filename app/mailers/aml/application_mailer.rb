# frozen_string_literal: true

module AML
  class ApplicationMailer < ActionMailer::Base
    # советуют ловить только ActiveJob::DeserializationError
    # но мне интересно что там вообще может падать
    rescue_from StandardError do |exception|
      AML.logger.error exception
      Bugsnag.notify exception if defined? Bugsnag
      raise exception
    end
  end
end
