Rails.application.routes.draw do
  resources :appointments
  resources :schedules
  resources :users
  resource :session

  root to: redirect('signin')
  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  get 'getdata' => 'appointments#owner_appointments', as: 'owner_appointments'

  resources :users do
    resources :schedules
  end

  # resources :users do
  #   resources :appointments
  # end
end