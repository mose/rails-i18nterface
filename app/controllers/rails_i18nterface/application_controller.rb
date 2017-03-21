# encoding: utf-8

module RailsI18nterface
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
end
