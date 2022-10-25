Rails.application.routes.draw do
  root 'home#top'

  namespace :admin do
    root "top#index"
    resources :users, only: [:index, :show] do
      member do
        patch :grant_admin
      end
    end
  end

  resources :chats do
    resources :messages, only: [:create]
  end
  post "chats/:id" => "chats#create_individual", as: "chats_individual"

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
    resources :entries, only: [:index, :create, :new ]
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

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

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
