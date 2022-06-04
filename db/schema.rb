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

ActiveRecord::Schema[7.0].define(version: 2022_06_02_192545) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["event_id"], name: "index_event_dates_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.boolean "published", default: false, null: false
  end

  create_table "feature_flags", force: :cascade do |t|
    t.string "key"
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_feature_flags_on_key", unique: true
  end

  create_table "lan_parties", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false, null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer "sort", default: 0, null: false
    t.bigint "parent_id"
    t.string "static_page_name"
    t.boolean "visible", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title_en", null: false
    t.string "title_de", null: false
    t.string "type", default: "MenuLinkItem", null: false
    t.integer "page_id"
    t.boolean "use_namespace_for_active_detection", default: false, null: false
    t.index ["parent_id"], name: "index_menu_items_on_parent_id"
  end

  create_table "news_posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.bigint "user_id", null: false
    t.boolean "published", default: false, null: false
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_news_posts_on_user_id"
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
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.boolean "published", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_pages_on_title", unique: true
    t.index ["url"], name: "index_pages_on_url", unique: true
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
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["seat_category_id"], name: "index_products_on_seat_category_id"
  end

  create_table "seat_categories", force: :cascade do |t|
    t.bigint "lan_party_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "#000", null: false
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

  create_table "tickets", force: :cascade do |t|
    t.bigint "lan_party_id", null: false
    t.bigint "seat_category_id", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lan_party_id"], name: "index_tickets_on_lan_party_id"
    t.index ["order_id"], name: "index_tickets_on_order_id"
    t.index ["seat_category_id"], name: "index_tickets_on_seat_category_id"
  end

  create_table "user_addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "street", null: false
    t.string "zip_code", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_addresses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token_digest"
    t.boolean "activated", default: false, null: false
    t.string "activation_token"
    t.string "password_reset_token_digest"
    t.datetime "password_reset_token_created_at", precision: nil
    t.string "username", null: false
    t.string "website"
    t.string "preferred_locale"
    t.boolean "use_dark_mode", default: false, null: false
    t.string "otp_secret_key"
    t.boolean "two_factor_enabled", default: false
    t.text "otp_backup_codes"
    t.datetime "remember_me_token_created_at", precision: nil
    t.boolean "user_admin_permission", default: false, null: false
    t.boolean "news_admin_permission", default: false, null: false
    t.boolean "event_admin_permission", default: false, null: false
    t.boolean "system_admin_permission", default: false, null: false
    t.boolean "page_admin_permission", default: false, null: false
    t.boolean "menu_items_admin_permission", default: false, null: false
    t.boolean "shop_admin_permission", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "product_variants"
  add_foreign_key "carts", "users"
  add_foreign_key "event_dates", "events"
  add_foreign_key "news_posts", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_variants"
  add_foreign_key "orders", "users"
  add_foreign_key "product_variants", "products"
  add_foreign_key "seat_categories", "lan_parties"
  add_foreign_key "seat_maps", "lan_parties"
  add_foreign_key "seats", "seat_categories"
  add_foreign_key "seats", "seat_maps"
  add_foreign_key "seats", "tickets"
  add_foreign_key "tickets", "lan_parties"
  add_foreign_key "tickets", "orders"
  add_foreign_key "tickets", "seat_categories"
  add_foreign_key "user_addresses", "users"
end
