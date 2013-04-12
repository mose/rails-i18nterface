ENV["RAILS_ENV"] ||= 'test'
$:<<File.expand_path("../../lib",__FILE__)

require 'rubygems'
require 'bundler'
require 'combustion'

Bundler.require :default, :test

require 'capybara/rspec'

Combustion.initialize! :active_record, :action_controller, :action_view, :sprockets

require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rails'
require 'rails-i18nterface'

new_root = File.expand_path(File.join("..", "internal"), __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.include Capybara::DSL, example_group: { file_path: /\bspec\/request\// }
  config.include RailsI18nterface::Engine.routes.url_helpers
  config.before(:each) do
    RailsI18nterface::Storage.stub!(:root_dir).and_return(new_root)
    RailsI18nterface::Keys.stub(:i18n_keys).and_return(:en)
    I18n.stub!(:default_locale).and_return(:en)
    I18n.stub!(:available_locales).and_return([:sv, :no, :en, :root])
  end
end

# improve the performance of the specs suite by not logging anything
# see http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Rails.logger.level = 4