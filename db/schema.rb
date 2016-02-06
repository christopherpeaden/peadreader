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

ActiveRecord::Schema.define(version: 20160206210629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url"
    t.integer  "user_id"
    t.integer  "category_id"
  end

  add_index "feeds", ["category_id"], name: "index_feeds_on_category_id", using: :btree
  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "published"
    t.integer  "feed_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "image_thumbnail_url"
  end

  add_index "items", ["feed_id"], name: "index_items_on_feed_id", using: :btree

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
    t.integer  "access_token_expiration"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

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
  end

  add_index "youtube_channels", ["user_id"], name: "index_youtube_channels_on_user_id", using: :btree

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
  end

  add_index "youtube_videos", ["playlist_id"], name: "index_youtube_videos_on_playlist_id", using: :btree
  add_index "youtube_videos", ["published_at"], name: "index_youtube_videos_on_published_at", using: :btree
  add_index "youtube_videos", ["title"], name: "index_youtube_videos_on_title", using: :btree
  add_index "youtube_videos", ["youtube_channel_id"], name: "index_youtube_videos_on_youtube_channel_id", using: :btree

  add_foreign_key "categories", "users"
  add_foreign_key "feeds", "categories"
  add_foreign_key "feeds", "users"
  add_foreign_key "items", "feeds"
  add_foreign_key "youtube_channels", "users"
  add_foreign_key "youtube_videos", "youtube_channels"
end
