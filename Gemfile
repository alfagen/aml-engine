source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in aml.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'active_link_to', github: 'BrandyMint/active_link_to'
gem 'dapi-archivable', require: 'archivable'

gem 'authority'
gem 'carrierwave'
gem 'fast_jsonapi', github: 'HoJSim/fast_jsonapi', branch: 'dev'
gem 'valid_email'
gem 'enumerize'
gem 'workflow', github: 'geekq/workflow'
gem 'ransack'
gem 'globalize', github: 'globalize/globalize', ref: 'HEAD'
gem 'globalize-accessors'

gem 'sendgrid-actionmailer', github: 'dreimannzelt/sendgrid-actionmailer', branch: :dynamic_template_data

gem 'money'
gem 'money-rails'

group :development, :test do
  gem 'database_rewinder'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
