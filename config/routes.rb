# == Route Map
#

# config/routes.rb
Rails.application.routes.draw do
  get 'places/index'
  require 'sidekiq/web'

  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'

  resources :users, param: :_username
  resources :taquillas, path: 'taquillas', param: :_id
  resources :riferos, only: [:index], path: 'riferos'
  resources :rifas, only: [:index, :create, :update]
  resources :wallets, only: [:index]
  resources :tickets, only: [:index]
  resources :draws, only: [:index, :show, :create], param: :id
  resources :places, only: [:index], param: :id

  # get 'draws/index'
  # get 'draws/show'
  # get 'draws/create'
  # get 'exchange/index'
  # get 'rifa_tickets/index'
  # get 'wallets/index'
  # get 'rifas/index'

  get '/draws/filter', to: 'draws#filter', param: :owner_id
  get '/rifas/tickets', to: 'tickets#index', param: :rifa_id
  get '/rifas/expired', to: 'rifas#expireds'
  get '/rifas/active', to: 'rifas#actives'
  get '/my-profile', to: 'profiles#index'
  get '/stats/rifas', to: 'stats#rifas_stats'
  
  post '/', to: 'application#test'
  post '/auth/login', to: 'authentication#login'
  post '/api/public/draws', to: 'draws#public_get'
  
  put '/places', to: 'places#sell_places'
end
