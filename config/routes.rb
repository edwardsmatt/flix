Rails.application.routes.draw do
  resources :favorites

  resource :session
  get 'signin' => 'sessions#new'

  resources :users
  get 'signup' => 'users#new'

  root "movies#index"
  resources :movies do
    resources :reviews
  end
end
