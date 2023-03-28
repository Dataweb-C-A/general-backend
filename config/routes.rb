# config/routes.rb
Rails.application.routes.draw do
  resources :users, param: :_username
  get '/my-profile', to: 'profiles#index'
  post '/auth/login', to: 'authentication#login'
end