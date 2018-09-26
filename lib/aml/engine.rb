module AML
  class Engine < ::Rails::Engine
    isolate_namespace AML
    require 'factory_bot'

    FactoryBot.definition_file_paths = %W(vendor/aml-engine/spec/dummy/factories)
  end
end
