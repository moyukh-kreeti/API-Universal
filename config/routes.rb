Rails.application.routes.draw do
  resources :users do
    resources :posts do
      get 'create_csv', on: :member
    end
  end
  root "users#index"

  post 'authentication/signup'
  post 'authentication/login'
end
