Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :web, path: "" do
    namespace :guests do
      resources :sessions, only: [:new]
      resources :passwords, only: [:new, :create]
      resources :registrations, only: [:new, :create]
    end

    namespace :users do
      resource :sessions, only: [:destroy, :create]

      resource :passwords, only: [:update]
      namespace :passwords do
        resources :reset, only: [:edit, :update], param: :token
      end

      resource :tokens, only: [:update]
      resource :registrations, only: [:destroy]

      namespace :settings do
        resource :api, only: [:show], controller: "api"
        resource :profile, only: [:show]
      end
    end

    resources :tasks, except: [:show], module: "tasks", controller: "items" do
      member do
        put :complete, to: "items/complete#update"
        put :incomplete, to: "items/incomplete#update"
      end

      collection do
        get :completed, to: "filter/completed#index"
        get :incomplete, to: "filter/incomplete#index"
      end
    end

    namespace :tasks do
      resources :lists, except: [:show] do
        member do
          put :select, to: "lists/select#update"
        end
      end
    end
  end

  root "web/guests/sessions#new"
end
