Rails.application.routes.draw do
  devise_for :users
  root 'records#index'
  resources :records
end
