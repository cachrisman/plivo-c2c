Rails.application.routes.draw do
  resources :calls
  root 'calls#new'
  post '/callback/hangup/:id', to: 'calls#hangup_callback', as: 'hangup_callback'
end
