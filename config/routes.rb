Rails.application.routes.draw do
  devise_for :admins

  root 'home#index'

  namespace :admin_backoffice do
    resources :client_wallets
    resources :currencies, only: %i[index create new] do
      post 'approve', on: :member
      post 'reject', on: :member
    end
    resources :categories, only: %i[index create new edit update]
    get '/pending_admins', to: 'registered_admins#approval'

    resources :bonus_conversions, only: %i[index new create]
    resources :registered_admins do
      post 'approve', on: :member
      post 'refuse', on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      get 'current_rate', to: 'exchanges_rate#current_rate'
      resources :client_wallets, only: %i[create]
      get 'client_wallet/balance', to: 'client_wallets#balance'
    end
  end
end
