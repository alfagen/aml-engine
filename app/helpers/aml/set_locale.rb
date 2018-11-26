module AML::SetLocale
  extend ActiveSupport::Concern

  included do
    append_before_action :set_locale
  end

  private
  def set_locale
    I18n.locale = available_locale(request.query_parameters[:locale]) ||
                  available_locale(session[:locale]) ||
                  available_locale(current_user.try(:locale)) ||
                  http_accept_language.compatible_language_from(I18n.available_locales) ||
                  I18n.default_locale
  end

  def available_locales
    @available_locales ||= I18n.available_locales.map(&:to_s)
  end

  def available_locale(locale)
    locale if available_locales.include? locale
  end
end
