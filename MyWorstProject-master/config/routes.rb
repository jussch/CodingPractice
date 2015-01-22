Rails.application.routes.draw do
  resources :users, only: [:create, :new, :show]
  resource :session, only: [:new, :create, :destroy]
  resources :goals do
    post 'complete', to: "goals#complete"
  end
  resources :comments, only: [:create, :destroy]
end
