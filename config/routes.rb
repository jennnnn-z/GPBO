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
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  # get 'home/search', to: 'home#search', as: :search


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

  get 'item_prices/new', to: 'item_prices#new', as: :new_item_price
  post 'item_prices', to: 'item_prices#create', as: :item_prices

  # get 'search/show', to: 'search#show', as: :search 
  get 'search', to: 'search#index', as: :search

  # resources :cart
  get 'cart/show', to: 'cart#show', as: :view_cart
  get 'cart/add_item/:item_id', to: 'cart#add_item', as: :add_item 
  get 'cart/remove_item/:item_id', to: 'cart#remove_item', as: :remove_item 
  get 'cart/empty_cart', to: 'cart#empty_cart', as: :empty_cart
  get 'checkout', to: 'cart#checkout', as: :checkout 
  
  patch 'items/:id/toggle_feature', to: 'items#toggle_feature', as: :toggle_feature 
  patch 'items/:id/toggle_active', to: 'items#toggle_active', as: :toggle_active 

  # get '/orders/:id/checkout', to: 'orders#checkout', as: :checkout 
  
  # root 'home#index'

end
