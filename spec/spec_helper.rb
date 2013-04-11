ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'bundler'

Bundler.require :default, :test

require 'capybara/rspec'

Combustion.initialize! :active_record, :action_controller, :action_view, :sprockets

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.include Capybara::DSL, example_group: { file_path: /\bspec\/request\// }
  config.include RailsI18nterface::Engine.routes.url_helpers
end