Rails.application.routes.draw do

  root "posts#index"

  resources :posts
  resources :users

  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
