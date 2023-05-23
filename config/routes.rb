# == Route Map
#

# config/routes.rb
Rails.application.routes.draw do
  require 'sidekiq/web'

  get 'draws/index'
  get 'draws/show'
  get 'draws/create'
  get 'exchange/index'
  get 'rifa_tickets/index'
  get 'wallets/index'

  get 'rifas/index'
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
  
  resources :users, param: :_username
  resources :taquillas, path: 'taquillas', param: :_id
  resources :riferos, only: [:index], path: 'riferos'
  resources :rifas, only: [:index, :create, :update]
  resources :wallets, only: [:index]
  resources :tickets, only: [:index]
  resources :draws, only: [:index]

  get '/rifas/tickets', to: 'tickets#index', param: :rifa_id


  get '/rifas/expired', to: 'rifas#expireds'
  get '/rifas/active', to: 'rifas#actives'
  get '/my-profile', to: 'profiles#index'
  post '/auth/login', to: 'authentication#login'
  
  ### Stats routes ###
  get '/stats/rifas', to: 'stats#rifas_stats'
  ### Stats routes ###
end
