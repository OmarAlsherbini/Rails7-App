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

ActiveRecord::Schema[7.0].define(version: 2022_08_29_145742) do
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
  add_foreign_key "test_children", "test_parents"
  add_foreign_key "test_parents", "test_children", column: "child_one"
  add_foreign_key "test_parents", "test_children", column: "child_two"
end
