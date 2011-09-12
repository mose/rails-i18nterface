Rails.application.routes.draw do

  mount RailsI18nterface::Engine => "/translate"
end
