Rails.application.routes.draw do
  root 'home#top'
  resources :posts do
    resource :post_likes, only: [:create, :destroy]
  end
  devise_for :users
  resources :users, only: [:show] do
    collection do
      get :settings
    end
    member do
      get  :follows
      get  :followers
    end
    resource :relationships, only: [:create, :destroy]
  end
end
