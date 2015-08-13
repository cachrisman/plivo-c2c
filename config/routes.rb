Rails.application.routes.draw do
  resources :calls
  root 'calls#new'
  get '/callback', to: 'calls#callback'
  get '/hangup/:id', to: 'calls#hangup', as: 'hangup'
end
