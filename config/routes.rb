Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :posts, only: %i[new create], constraints: { id: /[0-9]+/ } do
    resources :comments, only: %i[new create]
    resources :likes, only: %i[create]
  end

  resources :users, only: %i[index show], constraints: { id: /[0-9]+/ } do
    resources :posts, only: %i[index show]
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "users#index"
end
