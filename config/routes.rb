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

  resources :posts, only: [:index, :show, :create, :edit, :update, :destroy] do
    resource :post_likes, only: [:create, :destroy]
  end

  resources :projects do
    resources :affiliations, only: [:index, :show, :create, :new, :destroy] do
      member do
        patch :grant_master
      end
    end
    resources :project_posts, only: [:index, :create, :new, :edit, :update, :destroy]
    resources :recruitments, only: [:create, :new] do
      resources :entries, only: [:index]
      root "recruitments#project_recruitments"
    end
    get "recruitments/:id" => "recruitments#show", as: "show"
  end

  resources :recruitments, only: [:index, :show, :edit, :update, :destroy] do
    collection do
      get :dynamic_tag
    end
    member do
      post  :publish
      post  :unpublish
    end
    resources :entries, only: [:create, :new ]
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
