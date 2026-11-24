Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :trails, only: %i[ index show ] do
    resources :notes, only: :create
    resource :follow, only: %i[ create destroy ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "trails#index"
end
