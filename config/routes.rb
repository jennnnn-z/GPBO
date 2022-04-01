Rails.application.routes.draw do
  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # Only need two routes for the API
      get 'orders', to: 'orders#index'
      get 'customers/:id', to: 'customers#show'

      
    end
  end

  get 'home', to: 'home#index', as: :home


  resources :sessions 
  resources :users, except: [:show, :destroy]

  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :customers 
  resources :categories 
  resources :items 
  resources :orders 
  
  
  

end
