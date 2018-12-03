Rails.application.routes.draw do
  resources :users
  resource :session

  get 'root' => 'users#index'
  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
end
