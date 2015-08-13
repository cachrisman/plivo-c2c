Rails.application.routes.draw do
  get '/calls/active', to: 'calls#active', as: 'active_calls'
  resources :calls
  root 'calls#new'
  post '/calls/:id', to: 'calls#update'
  post '/callback/hangup/:id', to: 'calls#hangup_callback', as: 'hangup_callback'
end
