Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "sessions", to: "sessions#create"
      delete "sessions", to: "sessions#destroy"
      post "api_tokens", to: "api_tokens#create"
      delete "api_tokens", to: "api_tokens#destroy"
    end
  end
  namespace :web do
    post "sessions", to: "sessions#create"
    delete "sessions", to: "sessions#destroy"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
