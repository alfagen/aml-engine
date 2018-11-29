begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AML'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load 'rails/tasks/engine.rake'

load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end

namespace :doc do
  desc "Generate a workflow graph for a model passed e.g. as 'MODEL=Order'."
  task :workflow => :environment do
    require 'workflow/draw'
    Workflow::Draw::workflow_diagram(ENV['MODEL'].constantize)
  end
end

task :inc_version do
  old_version = AML.version
  version = old_version.split('.')
  version[-1] = (version[-1].to_i + 1).to_s
  new_version = version.join('.')
  begin
    File.write(AML.version_path, new_version)
    puts "Updated from #{old_version} to #{new_version}"
  rescue
    raise "Can't increment engine's version."
  end
end
