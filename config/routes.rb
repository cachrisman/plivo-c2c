Rails.application.routes.draw do
  resources :calls
  root 'calls#new'
  get '/calls/active', to: 'calls#active', as: 'active_calls'
  post '/calls/:id', to: 'calls#update'
  post '/callback/hangup/:id', to: 'calls#hangup_callback', as: 'hangup_callback'
end
