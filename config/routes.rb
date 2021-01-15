Rails.application.routes.draw do
  root 'home#index'

  # Login / Logout
  get '/login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users, only: %i[new create]
  resources :news, controller: :news_posts, as: :news_posts, only: %i[index show]

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :users
    resources :news, controller: :news_posts, as: :news_posts do
      collection do
        post :preview_markdown
      end
    end
  end
end
