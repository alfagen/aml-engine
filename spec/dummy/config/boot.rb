# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __dir__)

require 'logger'

# Fix for Ruby 3.2+ and Rails 6.1 compatibility
module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger
  end
end

require 'concurrent-ruby'
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../lib', __dir__)
