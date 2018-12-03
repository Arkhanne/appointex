Rails.application.routes.draw do
  resources :users
  resource :session

  get 'root' => 'sessions#new'
  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
end
