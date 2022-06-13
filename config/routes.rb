Rails.application.routes.draw do
  devise_for :admins
  
  root 'home#index'

  resources :currencies, only: [:index, :create, :new]
end