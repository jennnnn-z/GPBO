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

  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :customers
  resources :categories, except: [:show, :destroy] 
  resources :addresses 
  resources :items 
  resources :orders 
  
  patch '/items/:id/toggle_feature', to: 'items#toggle_feature', as: :toggle_feature 
  patch '/items/:id/toggle_active', to: 'items#toggle_active', as: :toggle_active 

  
  

end
