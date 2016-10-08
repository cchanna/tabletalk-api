Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post :login, to: 'users#login'
  post :logout, to: 'users#logout'

  resources :games, only: [:index, :create, :show] do
    member do
      post :join
    end
  end
end
