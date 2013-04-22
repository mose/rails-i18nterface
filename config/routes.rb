RailsI18nterface::Engine.routes.draw do
  root to: 'translate#index'

  put '/translate' => 'translate#update'
  get '/reload' => 'translate#reload', as: 'translate_reload'
  get '/export' => 'translate#export', as: 'translate_export'
  delete '/delete/*key' => 'translate#destroy', format: false
end
