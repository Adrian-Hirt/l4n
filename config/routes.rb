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

    resources :addresses, except: %i[show], controller: :user_addresses, as: :user_addresses
  end

  resources :news, only: %i[index show]
  resources :events, only: %i[index show]

  # Shop
  namespace :shop do
    get '/', to: 'home#index'

    resources :products, only: %i[show]
    resources :product_variants, only: [] do
      member do
        post :add_to_cart
      end
    end

    get :cart, to: 'cart#index'
    resources :cart_items, only: %i[destroy] do
      member do
        post :increase_quantity
        post :decrease_quantity
      end
    end

    get :checkout, to: 'checkout#show'
    patch :'checkout/set_address', to: 'checkout#set_address'
    post :'checkout/use_promotion_code', to: 'checkout#use_promotion_code'

    resources :orders, only: %i[index show] do
      member do
        delete :cancel_delayed_payment_pending
      end
    end
  end

  # Lan related stuff
  namespace :lan do
    get :seatmap, to: 'seatmap#index'
    scope '/seatmap' do
      get :seats, to: 'seatmap#seats'
      post :get_seat, to: 'seatmap#get_seat'
      post :remove_seat, to: 'seatmap#remove_seat'
      get :user_by_username, to: 'seatmap#user_by_username'
      post :assign_ticket, to: 'seatmap#assign_ticket'
      delete :remove_assignee, to: 'seatmap#remove_assignee'
    end
  end

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
    resources :news, controller: :news_posts, as: :news_posts

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
    resources :menu_items, except: %i[new create show] do
      collection do
        get :'new/link', action: :new_link
        post :'new/link', action: :create_link
        get :'new/dropdown', action: :new_dropdown
        post :'new/dropdown', action: :create_dropdown
      end
    end

    # Shop
    namespace :shop do
      get '/', to: 'dashboard#index', as: :dashboard

      # Products
      resources :products, except: %i[show]

      # Orders
      resources :orders, only: %i[index show] do
        member do
          delete :cancel_delayed_payment_pending
        end
      end

      # Product categories
      resources :product_categories

      # Promitions
      resources :promotions do
        member do
          get :add_codes
          patch :generate_additional_codes
          get :export_codes
        end
      end

      # Promotion codes
      resources :promotion_codes, only: %i[destroy]

      namespace :payment_assist do
        get :/, action: :index
        get '/:order_id', action: :show_order, as: :show_order
        patch '/:order_id/order_paid', action: :order_paid, as: :order_paid
      end
    end

    # LanParties and related stuff
    resources :lan_parties, shallow: true do
      resources :seat_categories, controller: 'lan_parties/seat_categories'
      resource :seat_map, controller: 'lan_parties/seat_map', only: %i[show update] do
        member do
          get :seats
          post :update_seats
        end
      end
      resources :tickets, controller: 'lan_parties/tickets', only: %i[index]
    end

    # Tournament system
    resources :tournaments, shallow: true do
      scope module: :tournaments do
        resources :phases
        resources :teams, except: %i[show] do
          member do
            post :register_for_tournament
            post :unregister_from_tournament
          end
        end
        resources :placements, only: %i[index]
        resources :matches, only: []
      end
    end

    # Markdown preview endpoint
    post :markdown_preview, to: 'markdown#preview'
  end

  # Wildcard route for dynamic pages. This **needs** to come last at all times
  get '*page', to: 'pages#show', page: /((?!rails|admin|paymentgateway).)*/
end
