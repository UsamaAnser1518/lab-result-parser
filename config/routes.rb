Rails.application.routes.draw do
  root 'results#index'

  resources :results, only: [:index, :new, :create]
end
