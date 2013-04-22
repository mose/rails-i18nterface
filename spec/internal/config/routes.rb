Rails.application.routes.draw do
  root to: 'application#index'
  mount RailsI18nterface::Engine => '/translate', as: 'translate_engine'
end
