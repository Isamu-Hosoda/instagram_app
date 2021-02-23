Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  resources :photos do
    #お気に入り登録/解除のルーティング
    resource :favorite
    resources :comments
  end
  
  resources :users do
    resource :follow
    resources :followings
    resources :followers
    
    #お気に入り一覧を見るためのルーティング
    resources :favorites
  end

  #検索のためのルーティング
  resources :users do
    collection do
      get 'search'
    end
  end
  
  resources :notifications, :only => :index
  resources :policy, :only => :index
end
