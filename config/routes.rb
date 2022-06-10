Rails.application.routes.draw do
  devise_for :admins

  root 'home#index'
  namespace(:admin_backoffice) do
    get '/admins_pendentes', to: 'registered_admin#approval'
    post '/:id/approve', to: 'registered_admin#approve', as: 'approve'
    post '/:id/refuse', to: 'registered_admin#refuse', as: 'refuse'
  end
end
