# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_07_095008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "schedule_id"
    t.bigint "owner_id"
    t.bigint "caller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caller_id"], name: "index_appointments_on_caller_id"
    t.index ["owner_id"], name: "index_appointments_on_owner_id"
    t.index ["schedule_id"], name: "index_appointments_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "week_day"
    t.integer "hour"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_schedules_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "gender"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "email"
    t.integer "user_type", default: 0
  end

  add_foreign_key "appointments", "schedules"
  add_foreign_key "appointments", "users", column: "caller_id"
  add_foreign_key "appointments", "users", column: "owner_id"
  add_foreign_key "schedules", "users", column: "owner_id"
end
