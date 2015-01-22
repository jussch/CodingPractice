Rails.application.routes.draw do

  root 'root#root'
  resources :posts, default: :json
end
