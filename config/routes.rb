Rails.application.routes.draw do
  root 'home#index'

  # == Login / Logout ===================================================================
  devise_for :users, path:        '',
                     path_names:  { sign_in: :login, sign_out: :logout, password: :reset_password },
                     controllers: { sessions: :sessions }

  # == Login / Logout for ScannerUser ===================================================
  devise_for :scanner_users, path:        'ticket_scanner',
                             path_names:  { sign_in: :login, sign_out: :logout },
                             controllers: { sessions: :scanner_user_sessions }

  # == Settings =========================================================================
  post 'locale/:locale', to: 'application#set_locale', as: :set_locale
  post 'toggle_dark_mode', to: 'application#toggle_dark_mode'

  # == Password resetting ===============================================================
  match '/request_password_reset', to: 'password_resets#request_password_reset', via: %i[get post]
  match '/reset_password', to: 'password_resets#reset_password', via: %i[get patch]

  # == Users ============================================================================
  resources :users, only: %i[show] do
    collection do
      get :activate
    end
  end

  # == User registration ================================================================
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  # == User settings ====================================================================
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

  # == News =============================================================================
  resources :news, only: %i[index show]

  # == Events ===========================================================================
  resources :events, only: %i[index show]

  # == Tournaments ======================================================================
  resources :tournaments, only: %i[index show], shallow: true do
    resources :tournament_teams, except: %i[index show] do
      member do
        post :register_for_tournament
        post :unregister_from_tournament
        post :join
      end
    end

    get :teams, to: 'tournament_teams#index'

    resources :standings, only: %i[index], controller: :tournament_phases
  end

  get 'teams/:id', to: 'tournament_teams#show', as: :team

  resources :tournament_team_members, only: %i[destroy] do
    member do
      post :promote
    end
  end

  resources :matches, only: %i[edit update], controller: :tournament_matches

  # == Shop =============================================================================
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
        post :process_free
      end
    end
  end

  # == Lan related ======================================================================
  namespace :lan do
    get :seatmap, to: 'seatmap#index'
    scope '/seatmap' do
      get :seats, to: 'seatmap#seats'
      post :get_seat, to: 'seatmap#get_seat'
      post :remove_seat, to: 'seatmap#remove_seat'
    end

    get :ticket, to: 'tickets#my_ticket'

    resources :tickets, only: [] do
      member do
        # Assign and remove assignation of tickets
        post :assign
        post :remove_assignee

        # Taking and removing a seat with a ticket
        post :take_seat
        post :remove_seat
      end
    end
  end

  # == Ticket Scanner ===================================================================
  namespace :ticket_scanner do
    get :/, action: :scanner
    post :info
    post :checkin
  end

  # == Admin panel ======================================================================
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
      resources :seat_categories, controller: 'lan_parties/seat_categories', except: %i[show]
      resource :seat_map, controller: 'lan_parties/seat_map', only: %i[show update] do
        member do
          get :seats
          post :update_seats
        end
      end
      resources :tickets, controller: 'lan_parties/tickets', only: %i[index show] do
        member do
          # Assign and remove assignation of tickets
          post :assign_user
          post :remove_assignee

          # Taking and removing a seat with a ticket
          post :assign_seat
          post :remove_seat

          # Checking in and reverting the check-in
          post :check_in
          post :revert_check_in
        end
      end
    end

    # Tournament system
    resources :tournaments, shallow: true, except: %i[destroy] do
      member do
        post :toggle_registration
      end
      scope module: :tournaments do
        resources :phases, except: %i[index] do
          member do
            post :generate_rounds
            post :update_seeding
            post :confirm_seeding
            post :generate_next_round_matches
            post :complete
          end
        end
        resources :teams, except: %i[show] do
          member do
            post :register_for_tournament
            post :unregister_from_tournament
            post :add_user
          end
        end
        resources :matches, only: %i[show update]
        resources :team_members, only: %i[destroy] do
          member do
            post :promote
          end
        end
      end
    end

    # ScannerUser management
    resources :scanner_users, except: %i[show]

    # Markdown preview endpoint
    post :markdown_preview, to: 'markdown#preview'
  end

  # == Dynamic pages ====================================================================
  # Wildcard route for dynamic pages. This **needs** to come last at all times
  get '*page', to: 'pages#show', page: /((?!rails|admin|paymentgateway).)*/
end
