# config/routes.rb
Rails.application.routes.draw do
  resources :users, param: :_username
  resources :taquillas, only: [:create, :show], path: 'taquillas', param: :id
  get '/my-profile', to: 'profiles#index'
  post '/auth/login', to: 'authentication#login'
end