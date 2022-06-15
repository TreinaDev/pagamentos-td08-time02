Rails.application.routes.draw do
  devise_for :admins

  root 'home#index'

  namespace(:admin_backoffice) do
    resources :currencies, only: %i[index create new] do
      post 'approve', on: :member
    end
    resources :categories, only: %i[index create new edit update]
    get '/pending_admins', to: 'registered_admins#approval'

    resources :registered_admins do
      post 'approve', on: :member
      post 'refuse', on: :member
    end
  end
end
