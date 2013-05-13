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
  s.summary     = "A rails engine for translating in a web page."
  s.description = "A rails engine adding an interface for translating and writing translation files. Works with rails 3 and 4."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "railties", ">= 3.1.0"
  s.add_dependency "rake", ">= 3.1.0"

  s.add_development_dependency "tzinfo", ">= 0.3.37"
  s.add_development_dependency "combustion", '~> 0.5.0'
  s.add_development_dependency "rspec", '~> 2.13.0'
  s.add_development_dependency "rspec-rails", '~> 2.13.0'
  s.add_development_dependency "capybara"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "metric_fu"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "sauce", '~> 2.3'
  s.add_development_dependency "rest-client"

end
