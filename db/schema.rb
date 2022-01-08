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

ActiveRecord::Schema.define(version: 2022_01_08_160605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
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
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "event_dates", force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_dates_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location"
    t.boolean "published", default: false, null: false
  end

  create_table "feature_flags", force: :cascade do |t|
    t.string "key"
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_feature_flags_on_key", unique: true
  end

  create_table "menu_items", force: :cascade do |t|
    t.integer "sort", default: 0, null: false
    t.bigint "parent_id"
    t.string "static_page_name"
    t.boolean "visible", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title_en", null: false
    t.string "title_de", null: false
    t.string "type", default: "MenuLinkItem", null: false
    t.integer "page_id"
    t.index ["parent_id"], name: "index_menu_items_on_parent_id"
  end

  create_table "news_posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.bigint "user_id", null: false
    t.boolean "published", default: false, null: false
    t.datetime "published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_news_posts_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.boolean "published", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_pages_on_title", unique: true
    t.index ["url"], name: "index_pages_on_url", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "on_sale", default: false, null: false
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username", null: false
    t.string "website"
    t.string "preferred_locale"
    t.boolean "use_dark_mode", default: false, null: false
    t.string "otp_secret_key"
    t.boolean "two_factor_enabled", default: false
    t.text "otp_backup_codes"
    t.boolean "activated", default: false, null: false
    t.string "activation_token"
    t.string "remember_me_token_digest"
    t.string "password_reset_token_digest"
    t.datetime "password_reset_token_created_at"
    t.datetime "remember_me_token_created_at"
    t.boolean "user_admin_permission", default: false, null: false
    t.boolean "news_admin_permission", default: false, null: false
    t.boolean "event_admin_permission", default: false, null: false
    t.boolean "system_admin_permission", default: false, null: false
    t.boolean "page_admin_permission", default: false, null: false
    t.boolean "menu_items_admin_permission", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "event_dates", "events"
  add_foreign_key "news_posts", "users"
end
