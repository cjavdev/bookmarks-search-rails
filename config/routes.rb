Rails.application.routes.draw do
  resources :bookmarks
  root "static_pages#root"

  get "/auth/:provider/callback", to: "sessions#create"
  post "/auth/:provider/callback", to: "sessions#create"
end
