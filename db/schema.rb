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

ActiveRecord::Schema.define(version: 2019_09_20_163108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "text"
    t.datetime "commented_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "sentiments", force: :cascade do |t|
    t.text "value"
    t.float "mixed_score"
    t.float "negative_score"
    t.float "neutral_score"
    t.float "positive_score"
    t.bigint "comment_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_sentiments_on_comment_id"
    t.index ["user_id"], name: "index_sentiments_on_user_id"
    t.index ["value"], name: "index_sentiments_on_value"
  end

  create_table "users", force: :cascade do |t|
    t.string "code"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_users_on_code"
  end

  add_foreign_key "comments", "users"
  add_foreign_key "sentiments", "comments"
  add_foreign_key "sentiments", "users"
end
