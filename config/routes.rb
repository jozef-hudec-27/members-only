Rails.application.routes.draw do
  devise_for :users, skip: :passwords
  devise_scope :user do
    resource :user_password, except: [:new, :show],
                                  path: 'users',
                                  controller: 'devise/passwords'
  end


  root 'posts#index'

  resources :posts
  resources :comments, only: [:create, :destroy]

  get '/my_posts', to: 'posts#my_posts'
  get '*path', to: redirect('/')
end
