$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "aml/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
    s.name        = "aml"
    s.version     = AML::VERSION
    s.authors     = ["Valentin Andreev", "Danil Pismenny"]
    s.email       = ["danil@brandymint.ru"]
    s.homepage    = "http://page.com"
    s.summary     = "Summary of AML."
    s.description = "Description of AML."
    s.license     = "MIT"

    s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

    s.test_files = Dir["spec/**/*"]

    s.add_runtime_dependency 'carrierwave'
    s.add_runtime_dependency 'noty_flash'
    s.add_runtime_dependency 'fast_jsonapi'
    s.add_runtime_dependency 'valid_email'
    s.add_runtime_dependency 'enumerize'
    s.add_runtime_dependency 'workflow', '~> 1.3.0'
    s.add_runtime_dependency 'ransack'
    s.add_runtime_dependency 'authority'
    s.add_runtime_dependency 'globalize'
    s.add_runtime_dependency 'globalize-accessors'
    s.add_runtime_dependency 'money', '~> 6.13'
    s.add_runtime_dependency 'money-rails', '~> 1.13'
    s.add_runtime_dependency 'sendgrid-actionmailer'
    s.add_runtime_dependency 'draper', '~> 3.1.0'
    s.add_runtime_dependency 'active_link_to'
    s.add_runtime_dependency 'slim'
    s.add_runtime_dependency 'slim-rails'
    s.add_runtime_dependency 'axlsx'
    s.add_runtime_dependency 'axlsx_rails', '~> 0.5.2'
    s.add_runtime_dependency 'kaminari'
    s.add_runtime_dependency 'rails', "~> 6.0.6"
    s.add_runtime_dependency "dapi-archivable", "~> 0.1.2"
    s.add_runtime_dependency 'jquery-rails'
    s.add_runtime_dependency 'jquery-ui-rails'
    s.add_runtime_dependency 'breadcrumbs_on_rails'
    s.add_runtime_dependency 'momentjs-rails', '>= 2.9.0'
    s.add_runtime_dependency 'bootstrap-sass', '~> 3.2'
    s.add_runtime_dependency 'bootstrap-kaminari-views'
    s.add_runtime_dependency 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
    s.add_runtime_dependency 'turbolinks'
    s.add_runtime_dependency 'coffee-rails'
    s.add_runtime_dependency 'font-awesome-rails'
    s.add_runtime_dependency 'simple_form'
    s.add_runtime_dependency 'sass-rails'
    s.add_runtime_dependency 'localized_render'
    s.add_runtime_dependency 'simple_form_bootstrap_inputs'
    s.add_runtime_dependency 'best_in_place'

    s.add_development_dependency "mysql2"
    s.add_development_dependency 'rubocop'
    s.add_development_dependency 'rubocop-rspec'
    s.add_development_dependency 'guard-bundler'
    s.add_development_dependency 'guard-ctags-bundler'
    s.add_development_dependency 'guard-rspec'
    s.add_development_dependency 'guard-rubocop'
    s.add_development_dependency 'pry'
    s.add_development_dependency 'pry-doc'
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    s.add_development_dependency 'byebug'
    # Добавляет show-routes и show-models
    # и делает рельсовую конслоль через pry
    s.add_development_dependency 'pry-rails'

    # show-method
    # hist --grep foo
    # Adds step-by-step debugging and stack navigation capabilities to pry using byebug.
    s.add_development_dependency 'pry-byebug'
    s.add_development_dependency 'test-prof', '~> 0.7.2'

    s.add_development_dependency 'sorcery'
    s.add_development_dependency 'activesupport'
    s.add_development_dependency 'semver'
    s.add_development_dependency 'factory_bot'
    s.add_development_dependency 'rspec-rails', '~> 3.7'
    s.add_development_dependency 'database_rewinder'
end
