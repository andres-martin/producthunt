Rails.application.routes.draw do
  # get 'password_resets/new'
  # get 'password_resets/edit'
  
  root 'products#index'
  get 'login',     to: 'sessions#new'
  post 'login',    to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/products', to: 'products#index'
  #get '/products/new', to: 'products#new', as: 'new_product'
  #post '/products', to: 'products#create'
  #get '/products/:id', to: 'products#show', as: 'product'
  #get '/products/:id/edit', to: 'products#edit', as: 'edit_product'
  #patch '/products/:id', to: 'products#update'
  #delete '/products/:id', to: 'products#destroy'
  resources :products do
    resource :vote, only: [:create, :destroy]
    resources :comments, only: [:create]
  end  
  resources :users, only: [:new, :create]
  resources :password_resets, only: [:new, :create, :edit, :update]
  
end
