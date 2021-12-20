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

  resources :users, only: %i[show] do
    collection do
      get :activate
    end
  end

  # User registration
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  namespace :settings do
    namespace :two_factor do
      get :/, action: :index
      get :activate
      post :activate, action: :activate_save
      delete :deactivate
    end

    namespace :profile do
      get :/, action: :edit
      patch :/, action: :update
    end

    namespace :avatar do
      match :/, via: %i[get patch], action: :index
      delete :/, action: :destroy
    end

    namespace :account do
      get :/, action: :index
      get :destroy, action: :init_destroy_account
      post :destroy, action: :destroy_account
    end
  end

  resources :news, only: %i[index show]
  resources :events, only: %i[index show]

  # Admin panel stuff
  namespace :admin do
    get '/', to: 'home#dashboard'

    # User management
    resources :users, only: %i[index new create show destroy] do
      member do
        get :profile, action: :edit, controller: 'users/profile'
        patch :profile, action: :update, controller: 'users/profile'

        get :permissions, action: :edit, controller: 'users/permissions'
        patch :permissions, action: :update, controller: 'users/permissions'

        match :avatar, action: :edit, controller: 'users/avatar', via: %i[get patch]
        delete :avatar, action: :destroy, controller: 'users/avatar'
      end
    end

    # News posts
    resources :news, controller: :news_posts, as: :news_posts do
      collection do
        post :preview_markdown
      end
    end

    # Events
    resources :events do
      collection do
        get :archive
      end
    end

    # Feature flags
    resources :feature_flags, only: %i[index] do
      collection do
        post :reinitialize
      end
      member do
        post :toggle
      end
    end

    # Pages
    resources :pages

    # Configurable menu items
    resources :menu_items
  end

  # Wildcard route for dynamic pages. This **needs** to come last at all times
  get '*page', to: 'pages#show', page: /((?!rails|admin).)*/
end
