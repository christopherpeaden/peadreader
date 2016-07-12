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

ActiveRecord::Schema.define(version: 20160613010029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_categories_on_user_id", using: :btree
  end

  create_table "categorizations", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "feed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "feeds", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "url"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_feeds_on_user_id", using: :btree
  end

  create_table "itemizations", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "item_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "published_at"
    t.integer  "feed_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "image_thumbnail_url"
    t.string   "feed_title"
    t.boolean  "favorite",            default: false
    t.boolean  "saved_for_later",     default: false
    t.integer  "user_id"
    t.index ["favorite"], name: "index_items_on_favorite", using: :btree
    t.index ["feed_id"], name: "index_items_on_feed_id", using: :btree
    t.index ["saved_for_later"], name: "index_items_on_saved_for_later", using: :btree
    t.index ["user_id"], name: "index_items_on_user_id", using: :btree
  end

  create_table "job_watchers", force: :cascade do |t|
    t.boolean  "completed",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_job_watchers_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "name"
    t.string   "uid"
    t.string   "provider"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "access_token"
    t.string   "refresh_token"
    t.integer  "access_token_expiration", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "youtube_channels", force: :cascade do |t|
    t.string   "title"
    t.string   "channel_id"
    t.string   "url"
    t.string   "video_count"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image"
    t.integer  "user_id"
    t.string   "upload_playlist_id"
    t.index ["user_id"], name: "index_youtube_channels_on_user_id", using: :btree
  end

  create_table "youtube_videos", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "playlist_id"
    t.string   "video_id"
    t.string   "image"
    t.integer  "youtube_channel_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "published_at"
    t.string   "channel_id"
    t.index ["playlist_id"], name: "index_youtube_videos_on_playlist_id", using: :btree
    t.index ["published_at"], name: "index_youtube_videos_on_published_at", using: :btree
    t.index ["title"], name: "index_youtube_videos_on_title", using: :btree
    t.index ["youtube_channel_id"], name: "index_youtube_videos_on_youtube_channel_id", using: :btree
  end

  add_foreign_key "categories", "users"
  add_foreign_key "feeds", "users"
  add_foreign_key "items", "feeds"
  add_foreign_key "items", "users"
  add_foreign_key "job_watchers", "users"
  add_foreign_key "youtube_channels", "users"
  add_foreign_key "youtube_videos", "youtube_channels"
end
