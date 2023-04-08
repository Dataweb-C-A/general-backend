# == Route Map
#

# config/routes.rb
Rails.application.routes.draw do
  get 'wallets/index'
  require 'sidekiq/web'

  get 'rifas/index'
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq/token=682670148277b817c481f663e47ae770a9c1257c490c76e6692d02e8c7cc33da'
  
  resources :users, param: :_username
  resources :taquillas, path: 'taquillas', param: :_id
  resources :riferos, only: [:index], path: 'riferos'
  resources :rifas, only: [:index, :create, :update]
  resources :stats, only: [:index]
  resources :wallets, only: [:index]


  get '/rifas/expired', to: 'rifas#expireds'
  get '/rifas/active', to: 'rifas#actives'
  get '/my-profile', to: 'profiles#index'
  post '/auth/login', to: 'authentication#login'
end
