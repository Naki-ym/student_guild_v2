Rails.application.routes.draw do
  root 'home#top'

  resources :posts do
    resource :post_likes, only: [:create, :destroy]
  end

  resources :projects do
    collection do
      get :myprojects
      get :dynamic_tag
    end
    member do
      post  :publish
      post  :unpublish
    end
  end

  resources :tags, only: [:index, :create, :new, :edit, :update, :destroy] do
    collection do
      get :sort
    end
  end

  resources :tag_categories, only: [:index, :create, :new, :edit, :update, :destroy] do
    collection do
      get :sort
    end
  end

  devise_for :users

  resources :users, only: [:show] do
    collection do
      get :admin_settings
      get :settings
    end
    member do
      get  :follows
      get  :followers
    end
    resource :relationships, only: [:create, :destroy]
  end
end
