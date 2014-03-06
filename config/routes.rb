Rails.application.routes.draw do
  resource :session

  resources :users
  get 'signup' => 'users#new'

  root "movies#index"
  resources :movies do
    resources :reviews
  end
end
