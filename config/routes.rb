Rails.application.routes.draw do
  devise_for :admins
  
  root 'home#index'
end
