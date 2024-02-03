Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Add 'devise' to users
  # devise_for :users
  devise_for :users

  resources :users, only: %i[index show], constraints: { id: /[0-9]+/ }, shallow: true do
    resources :posts, only: %i[index show new create destroy] do
      resources :comments, only: %i[new create destroy]
      resources :likes, only: %i[create]
    end
  end

  # API endpoint
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        resources :posts, only: [:index] do
          resources :comments, only: %i[index create]
        end
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "users#index"
end
