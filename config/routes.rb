Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :web, path: "" do
    namespace :guests do
      get "/sign_in", to: "sessions#new"
      get "/sign_up", to: "registrations#new"
      get "/reset_password", to: "passwords#new"

      post "/sign_up", to: "registrations#create"
      post "/reset_password", to: "passwords#create"
    end

    namespace :users do
      post "/sign_in", to: "sessions#create"
      delete "/sign_out", to: "sessions#destroy"

      put "/password", to: "passwords#update"

      get "/passwords/reset", to: "passwords/reset#edit"
      put "/passwords/reset", to: "passwords/reset#update"
    end

    namespace :tasks do
      get "/new", to: "item#new"
      get "/edit/:id", to: "item#edit", as: :edit

      scope module: :filtered do
        get "/completed", to: "completed#index"
        get "/incomplete", to: "incomplete#index"
      end

      get "/lists", to: "lists#index"
    end

    namespace :settings do
      get "/profile", to: "profile#show"
    end
  end

  root "web/guests/sessions#new"
end
