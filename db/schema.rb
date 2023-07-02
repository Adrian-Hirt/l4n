# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_02_194629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.bigint "lan_party_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lan_party_id"], name: "index_achievements_on_lan_party_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "api_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_api_applications_on_name", unique: true
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_variant_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_variant_id"], name: "index_cart_items_on_product_variant_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id", unique: true
  end

  create_table "event_dates", force: :cascade do |t|
    t.datetime "start_date", precision: nil, null: false
    t.datetime "end_date", precision: nil, null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.index ["event_id"], name: "index_event_dates_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false, null: false
  end

  create_table "feature_flags", force: :cascade do |t|
    t.string "key"
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_feature_flags_on_key", unique: true
  end

  create_table "footer_logos", force: :cascade do |t|
    t.integer "sort", default: 0, null: false
    t.boolean "visible", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
  end

  create_table "lan_parties", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false, null: false
    t.datetime "event_start"
    t.datetime "event_end"
    t.string "location"
    t.boolean "sidebar_active", default: true, null: false
    t.integer "sort", default: 0, null: false
    t.boolean "timetable_enabled", default: true, null: false
    t.boolean "seatmap_enabled", default: true, null: false
    t.boolean "users_may_have_multiple_tickets_assigned", default: false, null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer "sort", default: 0, null: false
    t.bigint "parent_id"
    t.string "static_page_name"
    t.boolean "visible", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "type", default: "MenuLinkItem", null: false
    t.integer "page_id"
    t.boolean "use_namespace_for_active_detection", default: false, null: false
    t.string "external_link"
    t.bigint "lan_party_id"
    t.index ["lan_party_id"], name: "index_menu_items_on_lan_party_id"
    t.index ["parent_id"], name: "index_menu_items_on_parent_id"
  end

  create_table "news_posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.boolean "published", default: false, null: false
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_openid_requests", force: :cascade do |t|
    t.bigint "access_grant_id", null: false
    t.string "nonce", null: false
    t.index ["access_grant_id"], name: "index_oauth_openid_requests_on_access_grant_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_variant_id"
    t.integer "quantity"
    t.integer "price_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_name"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_variant_id"], name: "index_order_items_on_product_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "cleanup_timestamp"
    t.string "status", default: "created", null: false
    t.string "billing_address_first_name"
    t.string "billing_address_last_name"
    t.string "billing_address_street"
    t.string "billing_address_zip_code"
    t.string "billing_address_city"
    t.string "payment_gateway_name"
    t.string "payment_gateway_payment_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.boolean "gtcs_accepted", default: false, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.index ["uuid"], name: "index_orders_on_uuid", unique: true
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.boolean "published", default: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "use_sidebar", default: true, null: false
    t.string "type", default: "ContentPage", null: false
    t.string "redirects_to"
    t.index ["title"], name: "index_pages_on_title", unique: true
    t.index ["url"], name: "index_pages_on_url", unique: true
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "sort", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_product_categories_on_name", unique: true
  end

  create_table "product_variants", force: :cascade do |t|
    t.string "name"
    t.bigint "product_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "on_sale", default: false, null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "availability", default: 0, null: false
    t.integer "inventory", default: 0, null: false
    t.string "enabled_product_behaviours"
    t.bigint "seat_category_id"
    t.bigint "product_category_id"
    t.integer "sort", default: 0, null: false
    t.bigint "from_product_id"
    t.bigint "to_product_id"
    t.integer "total_inventory", default: 0, null: false
    t.boolean "show_availability", default: false, null: false
    t.boolean "archived", default: false, null: false
    t.index ["from_product_id"], name: "index_products_on_from_product_id"
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["seat_category_id"], name: "index_products_on_seat_category_id"
    t.index ["to_product_id"], name: "index_products_on_to_product_id"
  end

  create_table "promotion_code_mappings", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "promotion_code_id", null: false
    t.bigint "order_item_id"
    t.integer "applied_reduction_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_promotion_code_mappings_on_order_id"
    t.index ["order_item_id"], name: "index_promotion_code_mappings_on_order_item_id"
    t.index ["promotion_code_id"], name: "index_promotion_code_mappings_on_promotion_code_id"
  end

  create_table "promotion_codes", force: :cascade do |t|
    t.bigint "promotion_id", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "used", default: false, null: false
    t.index ["code"], name: "index_promotion_codes_on_code", unique: true
    t.index ["promotion_id"], name: "index_promotion_codes_on_promotion_id"
  end

  create_table "promotion_products", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "promotion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_promotion_products_on_product_id"
    t.index ["promotion_id"], name: "index_promotion_products_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: false, null: false
    t.string "code_type", null: false
    t.integer "reduction_cents"
    t.string "code_prefix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_promotions_on_name", unique: true
  end

  create_table "scanner_users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lan_party_id"
    t.index ["lan_party_id"], name: "index_scanner_users_on_lan_party_id"
    t.index ["name"], name: "index_scanner_users_on_name", unique: true
  end

  create_table "seat_categories", force: :cascade do |t|
    t.bigint "lan_party_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "#000", null: false
    t.boolean "relevant_for_counter", default: true, null: false
    t.index ["lan_party_id"], name: "index_seat_categories_on_lan_party_id"
  end

  create_table "seat_maps", force: :cascade do |t|
    t.bigint "lan_party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "background_height", default: 0, null: false
    t.integer "background_width", default: 0, null: false
    t.integer "canvas_height", default: 500, null: false
    t.integer "canvas_width", default: 800, null: false
    t.index ["lan_party_id"], name: "index_seat_maps_on_lan_party_id"
  end

  create_table "seats", force: :cascade do |t|
    t.bigint "seat_map_id", null: false
    t.bigint "seat_category_id", null: false
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ticket_id"
    t.string "name"
    t.index ["seat_category_id"], name: "index_seats_on_seat_category_id"
    t.index ["seat_map_id"], name: "index_seats_on_seat_map_id"
    t.index ["ticket_id"], name: "index_seats_on_ticket_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "sidebar_blocks", force: :cascade do |t|
    t.boolean "visible", default: true, null: false
    t.string "title", null: false
    t.text "content"
    t.integer "sort", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "startpage_banners", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "visible", default: false, null: false
    t.integer "height", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "startpage_blocks", force: :cascade do |t|
    t.boolean "visible", default: true, null: false
    t.string "title"
    t.text "content"
    t.integer "sort", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "styling_variables", force: :cascade do |t|
    t.string "key", null: false
    t.string "light_mode_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dark_mode_value"
    t.index ["key"], name: "index_styling_variables_on_key", unique: true
  end

  create_table "ticket_upgrades", force: :cascade do |t|
    t.bigint "lan_party_id", null: false
    t.bigint "from_product_id", null: false
    t.bigint "to_product_id", null: false
    t.bigint "order_id", null: false
    t.boolean "used", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_product_id"], name: "index_ticket_upgrades_on_from_product_id"
    t.index ["lan_party_id"], name: "index_ticket_upgrades_on_lan_party_id"
    t.index ["order_id"], name: "index_ticket_upgrades_on_order_id"
    t.index ["to_product_id"], name: "index_ticket_upgrades_on_to_product_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "lan_party_id", null: false
    t.bigint "seat_category_id", null: false
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "assignee_id"
    t.string "status", default: "created", null: false
    t.string "product_variant_name"
    t.index ["assignee_id"], name: "index_tickets_on_assignee_id"
    t.index ["lan_party_id"], name: "index_tickets_on_lan_party_id"
    t.index ["order_id"], name: "index_tickets_on_order_id"
    t.index ["seat_category_id"], name: "index_tickets_on_seat_category_id"
  end

  create_table "timetable_categories", force: :cascade do |t|
    t.bigint "timetable_id", null: false
    t.string "name", null: false
    t.integer "order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timetable_id"], name: "index_timetable_categories_on_timetable_id"
  end

  create_table "timetable_entries", force: :cascade do |t|
    t.bigint "timetable_category_id", null: false
    t.string "title", null: false
    t.datetime "entry_start", null: false
    t.datetime "entry_end", null: false
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timetable_category_id"], name: "index_timetable_entries_on_timetable_category_id"
  end

  create_table "timetables", force: :cascade do |t|
    t.bigint "lan_party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.index ["lan_party_id"], name: "index_timetables_on_lan_party_id", unique: true
  end

  create_table "tournament_matches", force: :cascade do |t|
    t.bigint "tournament_round_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "home_id"
    t.bigint "away_id"
    t.bigint "winner_id"
    t.boolean "draw", default: false, null: false
    t.integer "home_score", default: 0, null: false
    t.integer "away_score", default: 0, null: false
    t.string "result_status", default: "missing", null: false
    t.bigint "reporter_id"
    t.index ["away_id"], name: "index_tournament_matches_on_away_id"
    t.index ["home_id"], name: "index_tournament_matches_on_home_id"
    t.index ["reporter_id"], name: "index_tournament_matches_on_reporter_id"
    t.index ["tournament_round_id"], name: "index_tournament_matches_on_tournament_round_id"
    t.index ["winner_id"], name: "index_tournament_matches_on_winner_id"
  end

  create_table "tournament_phase_teams", force: :cascade do |t|
    t.bigint "tournament_phase_id", null: false
    t.bigint "tournament_team_id", null: false
    t.integer "seed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score", default: 0, null: false
    t.index ["tournament_phase_id"], name: "index_tournament_phase_teams_on_tournament_phase_id"
    t.index ["tournament_team_id"], name: "index_tournament_phase_teams_on_tournament_team_id"
  end

  create_table "tournament_phases", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.string "name", null: false
    t.integer "phase_number", null: false
    t.string "tournament_mode", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "created", null: false
    t.integer "size"
    t.boolean "auto_progress", default: false, null: false
    t.index ["tournament_id"], name: "index_tournament_phases_on_tournament_id"
  end

  create_table "tournament_rounds", force: :cascade do |t|
    t.bigint "tournament_phase_id", null: false
    t.integer "round_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_phase_id"], name: "index_tournament_rounds_on_tournament_phase_id"
  end

  create_table "tournament_team_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tournament_team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "captain", default: false, null: false
    t.index ["tournament_team_id"], name: "index_tournament_team_members_on_tournament_team_id"
    t.index ["user_id"], name: "index_tournament_team_members_on_user_id"
  end

  create_table "tournament_team_ranks", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.string "name", null: false
    t.integer "sort", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "tournament_id"], name: "index_tournament_team_ranks_on_name_and_tournament_id", unique: true
    t.index ["tournament_id"], name: "index_tournament_team_ranks_on_tournament_id"
  end

  create_table "tournament_teams", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", null: false
    t.string "name", null: false
    t.string "password_digest"
    t.bigint "tournament_team_rank_id"
    t.index ["name", "tournament_id"], name: "index_tournament_teams_on_name_and_tournament_id", unique: true
    t.index ["tournament_id"], name: "index_tournament_teams_on_tournament_id"
    t.index ["tournament_team_rank_id"], name: "index_tournament_teams_on_tournament_team_rank_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name", null: false
    t.integer "team_size", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "draft", null: false
    t.boolean "registration_open", default: false, null: false
    t.integer "max_number_of_participants", default: 0, null: false
    t.boolean "singleplayer", default: false, null: false
    t.bigint "lan_party_id"
    t.text "description"
    t.integer "frontend_order", default: 0, null: false
    t.boolean "teams_need_rank", default: false, null: false
    t.index ["lan_party_id"], name: "index_tournaments_on_lan_party_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_id", null: false
    t.datetime "awarded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id", "achievement_id"], name: "index_user_achievements_on_user_id_and_achievement_id", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.string "permission", null: false
    t.string "mode", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "permission"], name: "index_user_permissions_on_user_id_and_permission", unique: true
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "user_tournament_permissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tournament_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_user_tournament_permissions_on_tournament_id"
    t.index ["user_id", "tournament_id"], name: "index_user_tournament_permissions_on_user_id_and_tournament_id", unique: true
    t.index ["user_id"], name: "index_user_tournament_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.string "website"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "otp_secret"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login", default: false, null: false
    t.string "otp_backup_codes", array: true
    t.text "bio"
    t.string "steam_id"
    t.string "discord_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "color_theme_preference", default: "auto", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "product_variants"
  add_foreign_key "carts", "users"
  add_foreign_key "event_dates", "events"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_openid_requests", "oauth_access_grants", column: "access_grant_id", on_delete: :cascade
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_variants"
  add_foreign_key "orders", "users"
  add_foreign_key "product_variants", "products"
  add_foreign_key "products", "product_categories"
  add_foreign_key "products", "products", column: "from_product_id"
  add_foreign_key "products", "products", column: "to_product_id"
  add_foreign_key "promotion_code_mappings", "orders"
  add_foreign_key "promotion_code_mappings", "promotion_codes"
  add_foreign_key "promotion_codes", "promotions"
  add_foreign_key "promotion_products", "products"
  add_foreign_key "promotion_products", "promotions"
  add_foreign_key "seat_categories", "lan_parties"
  add_foreign_key "seat_maps", "lan_parties"
  add_foreign_key "seats", "seat_categories"
  add_foreign_key "seats", "seat_maps"
  add_foreign_key "seats", "tickets"
  add_foreign_key "ticket_upgrades", "lan_parties"
  add_foreign_key "ticket_upgrades", "orders"
  add_foreign_key "ticket_upgrades", "products", column: "from_product_id"
  add_foreign_key "ticket_upgrades", "products", column: "to_product_id"
  add_foreign_key "tickets", "lan_parties"
  add_foreign_key "tickets", "orders"
  add_foreign_key "tickets", "seat_categories"
  add_foreign_key "timetable_categories", "timetables"
  add_foreign_key "timetable_entries", "timetable_categories"
  add_foreign_key "timetables", "lan_parties"
  add_foreign_key "tournament_matches", "tournament_phase_teams", column: "away_id"
  add_foreign_key "tournament_matches", "tournament_phase_teams", column: "home_id"
  add_foreign_key "tournament_matches", "tournament_phase_teams", column: "reporter_id"
  add_foreign_key "tournament_matches", "tournament_phase_teams", column: "winner_id"
  add_foreign_key "tournament_matches", "tournament_rounds"
  add_foreign_key "tournament_phase_teams", "tournament_phases"
  add_foreign_key "tournament_phase_teams", "tournament_teams"
  add_foreign_key "tournament_phases", "tournaments"
  add_foreign_key "tournament_rounds", "tournament_phases"
  add_foreign_key "tournament_team_members", "tournament_teams"
  add_foreign_key "tournament_team_members", "users"
  add_foreign_key "tournament_team_ranks", "tournaments"
  add_foreign_key "tournament_teams", "tournament_team_ranks"
  add_foreign_key "tournament_teams", "tournaments"
  add_foreign_key "uploads", "users"
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_permissions", "users"
  add_foreign_key "user_tournament_permissions", "tournaments"
  add_foreign_key "user_tournament_permissions", "users"
end
