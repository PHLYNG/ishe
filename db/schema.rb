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

ActiveRecord::Schema.define(version: 20160928151836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "project_comments", force: :cascade do |t|
    t.text     "body"
    t.string   "author"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_comments_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "project_type"
    t.string   "street1"
    t.string   "street2"
    t.boolean  "project_complete"
    t.datetime "project_action_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "complete_button_after_click"
    t.string   "city"
    t.string   "state"
    t.string   "verify_photo_file_name"
    t.string   "verify_photo_content_type"
    t.integer  "verify_photo_file_size"
    t.datetime "verify_photo_updated_at"
  end

  create_table "user_join_projects", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_user_join_projects_on_project_id", using: :btree
    t.index ["user_id"], name: "index_user_join_projects_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "password_digest"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "motto"
    t.integer  "number_projects_complete", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "user_join_projects", "projects"
  add_foreign_key "user_join_projects", "users"
end
