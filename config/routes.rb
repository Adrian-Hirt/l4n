Rails.application.routes.draw do
  root 'home#index'

  # Login / Logout
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  match 'login/two_factor', to: 'sessions#two_factor', via: %i[get post]
  delete 'logout', to: 'sessions#destroy'

  post 'locale/:locale', to: 'application#set_locale', as: :set_locale
  post 'toggle_dark_mode', to: 'application#toggle_dark_mode'

  # Password resetting
  match '/request_password_reset', to: 'password_resets#request_password_reset', via: %i[get post]
  match '/reset_password', to: 'password_resets#reset_password', via: %i[get patch]

  resources :users, only: %i[new create show] do
    collection do
      get :activate
    end
  end

  namespace :settings do
    namespace :two_factor do
      get '/', action: :index
      get :activate
      post :activate, action: :activate_save
      delete :deactivate
    end

    namespace :profile do
      match '/', via: %i[get patch], action: :index
    end

    namespace :avatar do
      match '/', via: %i[get patch], action: :index
      delete '/', action: :destroy
    end
  end

  resources :news, controller: :news_posts, as: :news_posts, only: %i[index show]
  resources :events, only: %i[index show]

  namespace :admin do
    get '/',          to: 'home#dashboard'
    match 'settings', to: 'home#settings', via: %i[get patch]
    resources :users
    resources :news, controller: :news_posts, as: :news_posts do
      collection do
        post :preview_markdown
      end
    end
    resources :events do
      collection do
        get :archive
      end
    end
  end
end
