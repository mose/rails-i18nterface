Rails.application.routes.draw do

  mount Translate::Engine => "/translate"
end
