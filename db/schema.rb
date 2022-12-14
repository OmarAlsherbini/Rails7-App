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

ActiveRecord::Schema[7.0].define(version: 2022_11_27_122836) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_calendars", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_year"
    t.bigint "next_year"
    t.bigint "past_year"
    t.bigint "current_month"
    t.bigint "next_month"
    t.bigint "previous_month"
    t.bigint "two_next_year"
    t.bigint "two_past_year"
  end

  create_table "app_days", force: :cascade do |t|
    t.bigint "app_calendar_id", null: false
    t.bigint "app_year_id", null: false
    t.bigint "app_month_id", null: false
    t.integer "day"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_calendar_id"], name: "index_app_days_on_app_calendar_id"
    t.index ["app_month_id"], name: "index_app_days_on_app_month_id"
    t.index ["app_year_id"], name: "index_app_days_on_app_year_id"
  end

  create_table "app_months", force: :cascade do |t|
    t.bigint "app_calendar_id", null: false
    t.bigint "app_year_id", null: false
    t.integer "days"
    t.integer "numSpace"
    t.string "name"
    t.integer "month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_calendar_id"], name: "index_app_months_on_app_calendar_id"
    t.index ["app_year_id"], name: "index_app_months_on_app_year_id"
  end

  create_table "app_years", force: :cascade do |t|
    t.bigint "app_calendar_id", null: false
    t.integer "yr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_calendar_id"], name: "index_app_years_on_app_calendar_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "views"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendar_apps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "n_mon_span", default: 6
    t.integer "n_yr_span", default: 1
    t.boolean "include_current_month_in_past", default: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "month_app_id", null: false
    t.string "name"
    t.boolean "all_day", default: false, null: false
    t.boolean "overwritable", default: false, null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.integer "event_type", null: false
    t.string "event_details"
    t.integer "event_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_day"
    t.date "end_day"
    t.time "start_time"
    t.time "end_time"
    t.index ["month_app_id"], name: "index_events_on_month_app_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "month_apps", force: :cascade do |t|
    t.bigint "calendar_app_id", null: false
    t.string "name"
    t.integer "month"
    t.integer "days"
    t.integer "numSpace"
    t.integer "current_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_app_id"], name: "index_month_apps_on_calendar_app_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "views"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_children", force: :cascade do |t|
    t.bigint "test_parent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_parent_id"], name: "index_test_children_on_test_parent_id"
  end

  create_table "test_parents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "child_one"
    t.bigint "child_two"
  end

  create_table "user_events", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.string "user_first_name"
    t.string "user_last_name"
    t.string "user_phone_number"
    t.string "user_physical_address"
    t.string "user_lat_long"
    t.float "user_performance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_user_events_on_event_id"
    t.index ["user_id"], name: "index_user_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "mailing_address"
    t.string "phone_number"
    t.string "physical_address"
    t.string "lat_long"
    t.float "performance"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "app_calendars", "app_months", column: "current_month"
  add_foreign_key "app_calendars", "app_months", column: "next_month"
  add_foreign_key "app_calendars", "app_months", column: "previous_month"
  add_foreign_key "app_calendars", "app_years", column: "current_year"
  add_foreign_key "app_calendars", "app_years", column: "next_year"
  add_foreign_key "app_calendars", "app_years", column: "past_year"
  add_foreign_key "app_calendars", "app_years", column: "two_next_year"
  add_foreign_key "app_calendars", "app_years", column: "two_past_year"
  add_foreign_key "app_days", "app_calendars"
  add_foreign_key "app_days", "app_months"
  add_foreign_key "app_days", "app_years"
  add_foreign_key "app_months", "app_calendars"
  add_foreign_key "app_months", "app_years"
  add_foreign_key "app_years", "app_calendars"
  add_foreign_key "events", "month_apps"
  add_foreign_key "month_apps", "calendar_apps"
  add_foreign_key "test_children", "test_parents"
  add_foreign_key "test_parents", "test_children", column: "child_one"
  add_foreign_key "test_parents", "test_children", column: "child_two"
  add_foreign_key "user_events", "events"
  add_foreign_key "user_events", "users"
end
