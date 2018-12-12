Rails.application.routes.draw do
  root to: redirect('session/signin')

  resource :session, path_names: { new: 'signin' }

  get 'getdata' => 'appointments#owner_appointments', as: 'owner_appointments'
  resources :users do
    resources :appointments
    resources :schedules
  end
end
