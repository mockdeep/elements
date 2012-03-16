Elements::Application.routes.draw do
  get "elements/index"

  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'sign_up' => 'users#new', :as => 'sign_up'
  root :to => 'sessions#new'

  resources :users, :except => [ :destroy ]
  resources :sessions, :except => [ :edit, :update, :show ]
  resources :elements, :except => [ :show ]
end
