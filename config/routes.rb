Rails.application.routes.draw do
  resources :users do
    resources :posts
  end
  root "users#index"

  post 'authentication/signup'
  post 'authentication/login'
end
