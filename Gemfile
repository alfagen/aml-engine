source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in aml.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'dapi-archivable', require: 'archivable'

gem 'carrierwave'
gem 'authority'
gem 'fast_jsonapi', github: 'HoJSim/fast_jsonapi', branch: 'dev'
gem 'valid_email'
gem 'enumerize'
gem 'workflow', github: 'geekq/workflow'
gem 'sorcery'

group :development do
    gem 'mysql2'
    gem 'rubocop'
    gem 'rubocop-rspec'
    gem 'guard-bundler'
    gem 'guard-ctags-bundler'
    gem 'guard-rspec'
    gem 'guard-rubocop'
end

group :development, :test do
    gem 'pry'
    gem 'pry-doc'
    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    gem 'byebug', platforms: %i[mri mingw x64_mingw]
    # Добавляет show-routes и show-models
    # и делает рельсовую конслоль через pry
    gem 'pry-rails'

    # show-method
    # hist --grep foo
    # Adds step-by-step debugging and stack navigation capabilities to pry using byebug.
    gem 'pry-byebug'

    gem 'factory_bot'
    gem 'factory_bot_rails'
    gem 'rspec-rails', '~> 3.7'
    gem 'database_rewinder'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
