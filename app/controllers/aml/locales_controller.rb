require_relative 'application_controller'

module AML
  class LocalesController < ApplicationController
    def update
      self.authorization_performed = true
      locale = available_locale params[:locale]
      if locale.present?
        I18n.locale = session[:locale] = locale
      else
        flash.alert = "Такая локаль #{params[:locale]} не поддерживается"
      end
      redirect_back(fallback_location: root_path)
    end
  end
end
