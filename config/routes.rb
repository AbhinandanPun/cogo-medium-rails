Rails.application.routes.draw do
  # root "users#index"

  # users controller
  resources :users, only: [:show, :create, :update] do    
    collection do
      get 'history', to: 'users#history'
      get 'subscribe', to: 'users#subscribe'
      post 'login', to: 'users#login'
    end
  end

  # revision_histories controller
  get 'revisionhistories/', to: 'revision_histories#show'
  get 'revisionhistories/undo_delete/', to: 'revision_histories#undo_delete'

  # posts controller
  resources :posts, only: [:index, :destroy, :create, :show, :update], param: :id do
    collection do
      get 'share/:id', to: 'posts#share'
      get 'filter', to: 'posts#filter'
      get 'topic', to: 'posts#topic'
      get 'recommended', to: 'posts#recommend'
    end
  end

  # lists controller
  resources :lists, only: [:show, :create, :destroy], param: :list_id do
    member do
      put 'post/:post_id', to: 'lists#add_to_list'
      put 'post/:post_id', to: 'lists#remove_from_list'
    end
  end

  # search controller
  resources :search, only: [] do
    collection do
      get 'users', to: 'search#search_users'
      get 'posts', to: 'search#search_posts'
    end
  end

  # like, comment, follow, controller
  post '/like/:id', to: 'like#like', as: :like_post
  post '/comment/:id', to: 'comment#comment', as: :comment_post
  post '/follow/:username', to: 'follow#follow_user', as: :follow_user

  # shares controller
  get 'shares/lists/:id', to: 'shares#share_list'
  get 'shares/posts/:id', to: 'shares#share_post'


  # drafts controller
  post 'drafts/:id/post', to: 'drafts#post'
  resources :drafts, only: [:create, :update, :show, :destroy] 

  # subscripition controller
  get 'subscriptions', to: 'subscriptions#index'
  get 'subscriptions/redirect_to_payments', to: 'subscriptions#redirect_to_payments'
  get 'subscriptions/create', to:'subscriptions#create', as: :subscriptions_create # same not working with post
  
  # payments controller
  get 'payments', to: 'payments#create', as: :payments_create # redirect was not working with post
  get '/payment/success', to: 'payments#success', as: :payment_success
  get '/payment/failure', to: 'payments#failure', as: :payment_failure

end
