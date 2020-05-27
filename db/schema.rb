# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_27_075631) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "experience_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["experience_id"], name: "index_bookings_on_experience_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "item_attributes", force: :cascade do |t|
    t.string "activity_reference"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "item_categories", force: :cascade do |t|
    t.string "name"
    t.string "alias"
    t.string "activity_reference"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "item_experiences", force: :cascade do |t|
    t.integer "travel_time"
    t.bigint "experience_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["experience_id"], name: "index_item_experiences_on_experience_id"
    t.index ["item_id"], name: "index_item_experiences_on_item_id"
  end

  create_table "item_experiences_travel_kinds", force: :cascade do |t|
    t.bigint "travel_kinds_id", null: false
    t.bigint "item_experiences_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_experiences_id"], name: "index_item_experiences_travel_kinds_on_item_experiences_id"
    t.index ["travel_kinds_id"], name: "index_item_experiences_travel_kinds_on_travel_kinds_id"
  end

  create_table "item_operating_hours", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "operating_hour_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_item_operating_hours_on_item_id"
    t.index ["operating_hour_id"], name: "index_item_operating_hours_on_operating_hour_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "address"
    t.boolean "availability", default: true, null: false
    t.float "rating"
    t.integer "price_range"
    t.integer "review_count"
    t.bigint "activity_id"
    t.bigint "item_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image_url"
    t.index ["activity_id"], name: "index_items_on_activity_id"
    t.index ["item_category_id"], name: "index_items_on_item_category_id"
  end

  create_table "join_item_attrs", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "item_attribute_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_attribute_id"], name: "index_join_item_attrs_on_item_attribute_id"
    t.index ["item_id"], name: "index_join_item_attrs_on_item_id"
  end

  create_table "operating_hours", force: :cascade do |t|
    t.integer "day"
    t.time "open_time"
    t.time "close_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "url"
    t.bigint "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_photos_on_item_id"
  end

  create_table "search_activities", force: :cascade do |t|
    t.bigint "search_id", null: false
    t.bigint "activity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_search_activities_on_activity_id"
    t.index ["search_id"], name: "index_search_activities_on_search_id"
  end

  create_table "search_experiences", force: :cascade do |t|
    t.bigint "search_id"
    t.bigint "experience_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["experience_id"], name: "index_search_experiences_on_experience_id"
    t.index ["search_id"], name: "index_search_experiences_on_search_id"
  end

  create_table "searches", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "price_range", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "city"
    t.integer "experience_focus"
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "travel_kinds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "experiences"
  add_foreign_key "bookings", "users"
  add_foreign_key "item_experiences", "experiences"
  add_foreign_key "item_experiences", "items"
  add_foreign_key "item_experiences_travel_kinds", "item_experiences", column: "item_experiences_id"
  add_foreign_key "item_experiences_travel_kinds", "travel_kinds", column: "travel_kinds_id"
  add_foreign_key "item_operating_hours", "items"
  add_foreign_key "item_operating_hours", "operating_hours"
  add_foreign_key "items", "activities"
  add_foreign_key "items", "item_categories"
  add_foreign_key "join_item_attrs", "item_attributes"
  add_foreign_key "join_item_attrs", "items"
  add_foreign_key "photos", "items"
  add_foreign_key "search_activities", "activities"
  add_foreign_key "search_activities", "searches"
  add_foreign_key "search_experiences", "experiences"
  add_foreign_key "search_experiences", "searches"
  add_foreign_key "searches", "users"
end
