Rails.application.routes.draw do
  root "home#index"
  devise_for :users
  resources :photos do
    
    #お気に入り登録/解除のurl
    resource :favorite
    resources :comments
  end
  
  resources :users do
    resource :follow
    resources :followings
    resources :followers
    
    #お気に入り一覧を見るためのurl
    resources :favorites
  end
end
