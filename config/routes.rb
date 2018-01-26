Rails.application.routes.draw do
  root 'index#index'

  # mount Biovision::Base::Engine, at: '/'

  resources :projects

  namespace :admin do
    resources :projects do
      member do
        post 'priority', defaults: { format: :json }
        post 'toggle', defaults: { format: :json }
      end
    end
  end
end
