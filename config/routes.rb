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

      delete "/", to: "registrations#destroy"
    end

    namespace :tasks do
      get "/lists", to: "lists#index"
      get "/lists/new", to: "lists#new"
      post "/lists", to: "lists#create"
      get "/lists/:id", to: "lists#edit", as: :list_edit
      put "/lists/:id", to: "lists#update", as: :list_update
      put "/lists/:id/select", to: "lists/select#update", as: :list_select
      delete "/lists/:id", to: "lists#destroy", as: :list_delete

      scope module: :filtered do
        get "/incomplete", to: "incomplete#index"
        get "/completed", to: "completed#index"
        get "/all", to: "all#index"
      end

      post "/", to: "item#create"
      get "/new", to: "item#new"
      get "/:id", to: "item#edit", as: :edit
      put "/:id", to: "item#update"
      put "/:id/complete", to: "item/complete#update", as: :mark_as_completed
      put "/:id/incomplete", to: "item/incomplete#update", as: :mark_as_incomplete
      delete "/:id", to: "item#destroy"
    end

    namespace :settings do
      get "/profile", to: "profile#show"
    end
  end

  root "web/guests/sessions#new"
end
