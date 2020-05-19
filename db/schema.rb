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

ActiveRecord::Schema.define(version: 2020_05_18_143305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "idea_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["idea_id"], name: "index_bookings_on_idea_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "ideas", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "item_ideas", force: :cascade do |t|
    t.integer "travel_time"
    t.bigint "idea_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["idea_id"], name: "index_item_ideas_on_idea_id"
    t.index ["item_id"], name: "index_item_ideas_on_item_id"
  end

  create_table "item_kinds", force: :cascade do |t|
    t.string "name"
    t.bigint "item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_item_kinds_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "address"
    t.boolean "availability"
    t.time "open_time"
    t.time "close_time"
    t.integer "rating"
    t.integer "price_range"
    t.integer "price"
    t.string "days_closed"
    t.bigint "activity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_items_on_activity_id"
  end

  create_table "search_activities", force: :cascade do |t|
    t.bigint "search_id", null: false
    t.bigint "activity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_search_activities_on_activity_id"
    t.index ["search_id"], name: "index_search_activities_on_search_id"
  end

  create_table "searches", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "price_range", default: 0
    t.string "activity_kind"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "travel_kinds", force: :cascade do |t|
    t.string "name"
    t.bigint "item_idea_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_idea_id"], name: "index_travel_kinds_on_item_idea_id"
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

  add_foreign_key "bookings", "ideas"
  add_foreign_key "bookings", "users"
  add_foreign_key "item_ideas", "ideas"
  add_foreign_key "item_ideas", "items"
  add_foreign_key "item_kinds", "items"
  add_foreign_key "items", "activities"
  add_foreign_key "search_activities", "activities"
  add_foreign_key "search_activities", "searches"
  add_foreign_key "searches", "users"
  add_foreign_key "travel_kinds", "item_ideas"
end
