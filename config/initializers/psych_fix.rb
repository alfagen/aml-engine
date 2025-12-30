# Исправление совместимости Ruby 3.2 с Rails 5.2
# Проблема с ActionDispatch::Static middleware
if Rails::VERSION::MAJOR == 5 && RUBY_VERSION >= '3.0'
  module ActionDispatch
    class Static
      def initialize(app, path, cache_control = nil)
        @app = app
        @path = path
        @cache_control = cache_control
      end
    end
  end
end