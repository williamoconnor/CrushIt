# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150731233103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_correspondences", force: true do |t|
    t.string   "user_id"
    t.string   "expert_id"
    t.integer  "refreshed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.string   "file_path"
  end

  create_table "chats", force: true do |t|
    t.integer  "user_id"
    t.integer  "expert_id"
    t.integer  "renewals"
    t.integer  "rating"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dialog_id"
    t.boolean  "pending_renewal"
  end

  create_table "ended_chats", force: true do |t|
    t.integer  "expert_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experts", force: true do |t|
    t.string   "specialty"
    t.integer  "rating"
    t.integer  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_rating"
    t.string   "specialty2"
    t.string   "specialty3"
    t.string   "specialty4"
    t.integer  "correspondences"
    t.boolean  "availability"
    t.integer  "unpaid_correspondences"
    t.text     "bio"
    t.string   "photo_file_path"
  end

  create_table "specialties", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "age"
    t.string   "gender"
    t.string   "interest"
    t.string   "password"
    t.string   "qb_id"
    t.string   "expert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash"
    t.integer  "correspondences"
    t.boolean  "shared_to_fb"
    t.string   "qb_code"
  end

end
