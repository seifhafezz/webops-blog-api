Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  get "up" => "rails/health#show", as: :rails_health_check
  post '/signup', to: 'auth#signup'
  post '/login', to: 'auth#login'
  # Defines the root path route ("/")
  root "posts#index"
  resources :posts, only: [:index, :show, :create, :update, :destroy] do
    resources :comments, only: [:create] # Allow creating comments under a post
end
  resources :comments, only: [:update, :destroy] # Allow editing and deleting comments

end
