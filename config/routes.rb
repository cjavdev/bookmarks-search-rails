Rails.application.routes.draw do
  resources :bookmarks
  resource :checkout
  resource :billing
  root "static_pages#root"

  get "/auth/:provider/callback", to: "sessions#create"
  post "/auth/:provider/callback", to: "sessions#create"
  get "/logout", to: "sessions#logout"
end
