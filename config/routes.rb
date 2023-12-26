Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :users do
    resources :posts do
      get 'create_csv', on: :collection
    end
  end
  root "users#index"

  post 'authentication/signup'
  post 'authentication/login'
end
