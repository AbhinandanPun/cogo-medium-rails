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

ActiveRecord::Schema[7.0].define(version: 2023_08_12_102133) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id", "post_id"], name: "index_Comments_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "drafts", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.string "topic"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_drafts_on_user_id"
  end

  create_table "followings", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "followed_id"], name: "index_followings_on_follower_id_and_followed_id", unique: true
  end

  create_table "interaction_histories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.string "interaction_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_interaction_histories_on_post_id"
    t.index ["user_id", "post_id", "interaction_type"], name: "index_interaction_histories", unique: true
    t.index ["user_id"], name: "index_interaction_histories_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id", "post_id"], name: "index_likes_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "list_posts", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_list_posts_on_list_id"
    t.index ["post_id"], name: "index_list_posts_on_post_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "topic", null: false
    t.text "text", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "read_time", default: 0
    t.integer "like_count", default: 0
    t.integer "comment_count", default: 0
    t.integer "view_count", default: 0
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "revision_histories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "action"
    t.text "post_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_revision_histories_on_user_id"
  end

  create_table "share_lists", force: :cascade do |t|
    t.string "email_recipient"
    t.integer "user_id", null: false
    t.integer "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_share_lists_on_list_id"
    t.index ["user_id"], name: "index_share_lists_on_user_id"
  end

  create_table "share_posts", force: :cascade do |t|
    t.string "email_recipient"
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_share_posts_on_post_id"
    t.index ["user_id"], name: "index_share_posts_on_user_id"
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.string "subscription_plan_name"
    t.string "rajorpay_plan_id"
    t.integer "daily_view_limit"
    t.integer "amount"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "subscription_plan_id", null: false
    t.string "rajorpay_subscription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id", unique: true
  end

  create_table "user_article_saves", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_user_article_saves_on_post_id"
    t.index ["user_id"], name: "index_user_article_saves_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "follower_count", default: 0
    t.integer "following_count", default: 0
    t.string "customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_views_on_post_id"
    t.index ["user_id", "post_id"], name: "index_Views_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_views_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "posts", on_delete: :cascade
  add_foreign_key "comments", "users", on_delete: :cascade
  add_foreign_key "drafts", "users", on_delete: :cascade
  add_foreign_key "followings", "users", column: "followed_id", on_delete: :cascade
  add_foreign_key "followings", "users", column: "follower_id", on_delete: :cascade
  add_foreign_key "interaction_histories", "posts", on_delete: :cascade
  add_foreign_key "interaction_histories", "users", on_delete: :cascade
  add_foreign_key "likes", "posts", on_delete: :cascade
  add_foreign_key "likes", "users", on_delete: :cascade
  add_foreign_key "list_posts", "lists", on_delete: :cascade
  add_foreign_key "list_posts", "posts", on_delete: :cascade
  add_foreign_key "lists", "users", on_delete: :cascade
  add_foreign_key "posts", "users", on_delete: :cascade
  add_foreign_key "revision_histories", "users", on_delete: :cascade
  add_foreign_key "share_lists", "lists", on_delete: :cascade
  add_foreign_key "share_lists", "users", on_delete: :cascade
  add_foreign_key "share_posts", "posts", on_delete: :cascade
  add_foreign_key "share_posts", "users", on_delete: :cascade
  add_foreign_key "subscriptions", "users", on_delete: :cascade
  add_foreign_key "user_article_saves", "posts", on_delete: :cascade
  add_foreign_key "user_article_saves", "users", on_delete: :cascade
  add_foreign_key "views", "posts", on_delete: :cascade
  add_foreign_key "views", "users", on_delete: :cascade
end
