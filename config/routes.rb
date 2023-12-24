Rails.application.routes.draw do
  resources :users
  post 'authentication/login'
end
