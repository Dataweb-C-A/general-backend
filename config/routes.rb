# config/routes.rb
Rails.application.routes.draw do
  get 'rifas/index'
  mount ActionCable.server => '/cable'
  
  resources :users, param: :_username
  resources :taquillas, path: 'taquillas', param: :_id
  resources :riferos, only: [:index], path: 'riferos'
  resources :rifas, only: [:index]

  get '/my-profile', to: 'profiles#index'
  post '/auth/login', to: 'authentication#login'
end