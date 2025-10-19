require_relative 'boot'

# Fix Ruby 3.2+ Rails 6.1 compatibility by ensuring Logger is loaded
require 'logger'

# Require Rails components individually to avoid logger issues
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'rails/test_unit/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

require 'archivable'
require "aml"
require 'authority'
require 'carrierwave'
require 'valid_email'
require 'ransack'
require 'globalize-accessors'
require 'money'
require 'money-rails'
require 'slim-rails'
require 'caxlsx_rails'
require 'kaminari'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'breadcrumbs_on_rails'
require 'draper'
require 'momentjs-rails'
require 'bootstrap-sass'
require 'sass-rails'
require 'bootstrap-kaminari-views'
require 'bootstrap3-datetimepicker-rails'
require 'turbolinks'
require 'coffee-rails'
require 'font-awesome-rails'
require 'localized_render'
require 'database_rewinder'
require 'simple_form_bootstrap_inputs'
require 'best_in_place'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

