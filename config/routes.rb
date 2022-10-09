Rails.application.routes.draw do
  devise_for :users

  root 'posts#index'

  resources :posts
  resources :comments, only: [:create, :destroy]

  get '/my_posts', to: 'posts#my_posts'
end
