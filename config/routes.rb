Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  revise_auth

  resources :lists do
    resources :items, only: %i[new create edit update destroy]
  end

  root "lists#index"
end
