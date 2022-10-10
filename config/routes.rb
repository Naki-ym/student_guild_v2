Rails.application.routes.draw do
  root 'home#top'
  resources :posts do
    resource :post_likes, only: [:create, :destroy]
  end
  devise_for :users
  resources :users, only: [:show]
end
