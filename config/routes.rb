Rails.application.routes.draw do
  root "users#index"

  post '/users/signup', to: 'users#signup', as: :user_signup
  post '/users/login', to: 'users#login', as: :user_login
  resources :users, only: [:show, :create,:update], param: :username do    
    collection do
      get 'history', to: 'users#history'
    end
  end

  post '/follow/:username', to: 'follow#followUser', as: :follow_user
  post '/like/:post_id', to: 'like#like', as: :like_post
  post '/comment/:post_id', to: 'comment#comment', as: :comment_post

  resources :posts, only: [:index, :destroy, :show, :create, :update], param: :post_id , param: :post_id do
    collection do
      get 'filter', to: 'posts#filter'
      get 'topic/:topic', to: 'posts#topic'
      get 'recommended', to: 'posts#recommend'
    end
  end


  resources :search, only: [] do
    collection do
      get 'users', to: 'search#search_users'
      get 'posts', to: 'search#search_posts'
    end
  end

  post 'drafts/:id/post', to: 'drafts#post'
  resources :drafts, only: [:create, :update, :show, :destroy] 
end
