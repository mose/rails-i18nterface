$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails-i18nterface/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-i18nterface"
  s.version     = RailsI18nterface::VERSION
  s.authors     = ["Larry Sprock", "Artin Boghosain"]
  s.email       = ["lardawge@gmail.com"]
  s.homepage    = "https://github.com/lardawge/rails-i18nterface"
  s.summary     = "A rails 3.1 engine based interface for translating and writing translation files"
  s.description = "Add me please"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"

  s.add_development_dependency "sqlite3"
end
