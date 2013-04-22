$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails-i18nterface/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-i18nterface"
  s.version     = RailsI18nterface::VERSION
  s.authors     = ["Mose"]
  s.email       = ["mose@mose.com"]
  s.homepage    = "https://github.com/mose/rails-i18nterface"
  s.summary     = "A rails 3.1/4 engine for translating in a web page."
  s.description = "A rails 3.1/4 engine adding an interface for translating and writing translation files."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 3.1.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "combustion", '~> 0.4.0'
  s.add_development_dependency "rspec", '~> 2.13.0'
  s.add_development_dependency "rspec-rails", '~> 2.13.0'
  s.add_development_dependency "capybara"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rubocop"
end
