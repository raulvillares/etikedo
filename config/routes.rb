Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :lists do
    resources :items, only: %i[new create edit update destroy] do
      member do
        patch "move"
        patch "assign_label/:label_name", to: "items#assign_label", as: :assign_label
        patch "unassign_label/:label_name", to: "items#unassign_label", as: :unassign_label
      end
    end
  end

  # Defines the root path route ("/")
  root "lists#index"
end
