require 'combustion'
require 'rails-i18nterface'
require 'sqlite3'

Combustion.initialize! :active_record, :action_controller, :action_view

run Combustion::Application
