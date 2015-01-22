Rails.application.routes.draw do
  resource :session, only: [:create, :new, :destroy]
  resources :users, only: [:create, :new, :show]
  root to: "bands#index"

  resources :bands do
    resources :albums, only: [:new]
  end

  resources :albums, except: [:new, :index] do
    resources :tracks, only: [:new]
  end

  resources :tracks, except: [:new, :index] do
    resources :notes, only: [:create]
  end

  resources :notes, only: [:destroy]
end
