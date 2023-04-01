# config/routes.rb
Rails.application.routes.draw do
  require 'sidekiq/web'

  get 'rifas/index'
  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
  
  resources :users, param: :_username
  resources :taquillas, path: 'taquillas', param: :_id
  resources :riferos, only: [:index], path: 'riferos'
  resources :rifas, only: [:index]
  resources :stats, only: [:index]

  get '/my-profile', to: 'profiles#index'
  post '/auth/login', to: 'authentication#login'
end