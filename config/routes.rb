Rails.application.routes.draw do
  root 'home#index'

  resources :currencies, only: [:index, :create, :new]
end