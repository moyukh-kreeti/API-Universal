Rails.application.routes.draw do
  resources :documents
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

  resources :words do
    get 'meaning', to: :meaning, on: :collection
    get 'synonym', to: :synonym, on: :collection
  end
end
