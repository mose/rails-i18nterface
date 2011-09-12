Rails.application.routes.draw do
  mount RailsI18nterface::Engine => "/translate", as: "translator"
end
