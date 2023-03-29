# config/routes.rb
Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  
  resources :users, param: :_username
  resources :taquillas, path: 'taquillas', param: :_id

  get '/my-profile', to: 'profiles#index'
  post '/auth/login', to: 'authentication#login'
end