# encoding: utf-8

class ApplicationController < ActionController::Base

  def index
    @title = I18n.t 'title'
  end

end