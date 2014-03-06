Rails.application.routes.draw do
  resource :session
  get 'signin' => 'sessions#new'

  resources :users
  get 'signup' => 'users#new'

  root "movies#index"
  resources :movies do
    resources :reviews
  end
end
