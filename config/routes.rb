Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "user/refresh", to: "users#refresh"
      post "user/signup", to: "users#signup"
      post "user/signin", to: "users#signin"
      delete "user", to: "users#destroy"
      put "user", to: "users#update"
      get "user", to: "users#show"
      
      resources :clients
      resources :assets
      resources :simulations
      # @TODO: Add company routes
      # resources :companies
    end
  end
end
