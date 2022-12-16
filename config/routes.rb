Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "user/signup", to: "users#signup"
      post "user/signin", to: "users#signin"
      delete "user", to: "users#destroy"
      put "user", to: "users#update"
      get "user", to: "users#show"
    end
  end
end
