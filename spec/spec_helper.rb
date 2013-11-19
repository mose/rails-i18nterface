# encoding: utf-8

if ENV['COV']
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_filter '/db/'
    add_group 'Models', '/app/models/'
    add_group 'Controllers', '/app/controllers/'
    add_group 'Helpers', '/app/helpers/'
    add_group 'Lib', '/lib/'
  end
end

ENV['RAILS_ENV'] ||= 'test'
$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'bundler'
require 'combustion'

Bundler.require :default, :test

require 'capybara/rspec'

Combustion.initialize! :action_controller, :action_view, :sprockets

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'rails-i18nterface'

Capybara.server_port = 9090

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include RailsI18nterface::Engine.routes.url_helpers
  config.before(:each) do
    RailsI18nterface::Keys.stub(:i18n_keys).and_return(:en)
    I18n.stub!(:default_locale).and_return(:en)
    I18n.stub!(:available_locales).and_return([:sv, :no, :en, :root])
  end
end

# improve the performance of the specs suite by not logging anything
# see http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Rails.logger.level = 4

