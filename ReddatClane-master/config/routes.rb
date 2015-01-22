Rails.application.routes.draw do
  #--root to: redirect ""
  resources :users, only: [:new, :create, :show]
  resource :sessions, only: [:new, :create, :destroy]
  resources :subs, except: [:destroy] do
    resource :posts, only:[:new]
  end
  resources :posts

  resources :comments, only:[:show, :edit, :create] do
    resources :comments, only: [:new]
  end

  post '/posts/:id/upvote', to: 'posts#upvote', as: "upvote_post"
  post '/posts/:id/downvote', to: 'posts#downvote', as: "downvote_post"

  post '/comments/:id/upvote', to: 'comments#upvote', as: "upvote_comment"
  post '/comments/:id/downvote', to: 'comments#downvote', as: "downvote_comment"




end
