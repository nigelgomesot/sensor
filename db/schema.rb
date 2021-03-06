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

ActiveRecord::Schema.define(version: 2019_10_12_164312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "entities", force: :cascade do |t|
    t.bigint "message_id"
    t.bigint "user_id"
    t.string "category"
    t.decimal "score"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_entities_on_message_id"
    t.index ["user_id"], name: "index_entities_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "text"
    t.string "provider_message_uid"
    t.datetime "sent_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_message_uid"], name: "index_messages_on_provider_message_uid"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "sentiments", force: :cascade do |t|
    t.text "level"
    t.float "mixed_score"
    t.float "negative_score"
    t.float "neutral_score"
    t.float "positive_score"
    t.bigint "message_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_sentiments_on_level"
    t.index ["message_id"], name: "index_sentiments_on_message_id"
    t.index ["user_id"], name: "index_sentiments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "provider_user_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_user_uid"], name: "index_users_on_provider_user_uid"
  end

  add_foreign_key "entities", "messages"
  add_foreign_key "entities", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "sentiments", "messages"
  add_foreign_key "sentiments", "users"
end
