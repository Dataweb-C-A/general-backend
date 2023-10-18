# == Route Map
#

# config/routes.rb
Rails.application.routes.draw do
  get 'printer_notifications/index'
  get 'reports/index'
  get 'reports/private'
  get 'whitelists/index'
  resources :clients
  get 'inboxes/index'
  get 'places/index'
  require 'sidekiq/web'
  
  get '/menu/50-50', to: 'application#menu'

  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
  
  resources :denominations, only: [:update]
  resources :quadres, only: [:index]
  resources :users, param: :_username
  resources :taquillas, path: 'taquillas', param: :_id
  resources :riferos, only: [:index], path: 'riferos'
  resources :rifas, only: [:index, :create, :update]
  resources :wallets, only: [:index]
  resources :tickets, only: [:index]
  resources :draws, only: [:index, :show, :create], param: :id
  resources :places, only: [:index], param: :id
  resources :whitelists, only: [:index], param: :agency
  resources :exchange
  resources :clients

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
  get '/to-infinity', to: 'places#to_infinity'
  get '/draws_finder', to: 'draws#find', param: :id
  get '/api/public/draws', to: 'draws#all'
  get '/places/reports', to: 'reports#daily_earning_reports'
  get '/places/printer/infinity', to: 'places#printer_infinity'
  
  post '/', to: 'application#test'
  post '/auth/login', to: 'authentication#login'
  post '/api/public/draws', to: 'draws#public_get'
  
  post '/places', to: 'places#sell_places'
  post '/to-infinity', to: 'places#sell_infinity'
  get '/tickets/print', to: 'places#print_text'
end
