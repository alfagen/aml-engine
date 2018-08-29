$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "aml/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "aml"
  s.version     = AML::VERSION
  s.authors     = ["Authors"]
  s.email       = ["email"]
  s.homepage    = "http://page.com"
  s.summary     = "Summary of Aml."
  s.description = "Description of Aml."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "sqlite3"
end
