Rails.application.routes.draw do
  resources :schedules
  resources :users
  resource :session

  root to: redirect('signin')
  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
end