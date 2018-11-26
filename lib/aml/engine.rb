module AML
  class Engine < ::Rails::Engine
    isolate_namespace AML

    # Идея отсюда - https://github.com/thoughtbot/factory_bot_rails/pull/149/files?diff=split&short_path=04c6e90
    #
    initializer 'aml.factories', after: 'factory_bot.set_factory_paths' do
      FactoryBot.definition_file_paths << File.expand_path('../../../factories', __FILE__) if defined?(FactoryBot)
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'factories'

      g.assets false
      g.helper false
    end
  end
end
