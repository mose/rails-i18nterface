require 'rubygems'
require 'bundler'

#Bundler.require :default, :development
require 'combustion'
require 'rails-i18nterface'
#require 'sqlite3'

Combustion.initialize! :action_controller, :action_view, :sprockets
Combustion::Application.config.name = 'c'

run Combustion::Application
