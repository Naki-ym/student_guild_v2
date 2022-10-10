Rails.application.routes.draw do
  root 'home#top'
  devise_for :users
  resources :users, only: [:show]
  resources :posts
end
