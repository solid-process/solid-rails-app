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
      resource :registrations, only: [:destroy]
    end

    namespace :settings do
      resource :profile, only: [:show]
    end

    resources :tasks, except: [:show], controller: "tasks/items" do
      member do
        put :complete, to: "tasks/items/complete#update"
        put :incomplete, to: "tasks/items/incomplete#update"
      end

      collection do
        get :completed, to: "tasks/filter/completed#index"
        get :incomplete, to: "tasks/filter/incomplete#index"
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
