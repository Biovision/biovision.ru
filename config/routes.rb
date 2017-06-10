Rails.application.routes.draw do
  root 'index#index'

  mount Biovision::Base::Engine, at: '/'
end
