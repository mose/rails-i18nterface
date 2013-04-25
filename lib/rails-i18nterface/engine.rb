# encoding: utf-8

require 'rails'

module RailsI18nterface
  class Engine < ::Rails::Engine
    isolate_namespace RailsI18nterface
  end
end
