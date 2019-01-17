# frozen_string_literal: true

module AML
  class ApplicationMailer < ::ApplicationMailer
    class << self
      delegate :logger, to: AML
    end

    private

    delegate :logger, to: AML
  end
end
