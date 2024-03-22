Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  root "web/guests/sessions#new"

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

  namespace :api, constraints: {format: "json"} do
    namespace :v1 do
      namespace :users do
        resource :tokens, only: [:update]
        resource :sessions, only: [:create]
        resource :registrations, only: [:create, :destroy]

        resource :passwords, only: [:update]
        namespace :passwords do
          resource :reset, only: [:create, :update], param: :token
        end
      end

      resources :task_lists, only: [:index, :create, :update, :destroy] do
        resources :tasks, only: [:index, :create, :update, :destroy] do
          member do
            put :complete, to: "tasks/complete#update"
            put :incomplete, to: "tasks/incomplete#update"
          end
        end
      end
    end
  end
end
