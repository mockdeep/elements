Elements::Application.routes.draw do
  get "elements/index"

  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'sign_up' => 'users#new', :as => 'sign_up'
  root :to => 'elements#index'

  resources :users, :only => [ :new, :create ]
  resources :sessions, :only => [ :create ]
  resources :elements, :except => [ :show ]
end
