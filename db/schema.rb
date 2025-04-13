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

ActiveRecord::Schema[7.2].define(version: 2025_04_13_081230) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authorizations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forum_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "topic", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_forum_threads_on_user_id"
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content_name", limit: 100, null: false
    t.string "reference", limit: 1000
    t.string "description", limit: 1000
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "thread_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "forum_thread_id", null: false
    t.bigint "thread_comment_id", default: 0
    t.string "content", limit: 1000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_thread_comments_on_created_at"
    t.index ["forum_thread_id"], name: "index_thread_comments_on_forum_thread_id"
    t.index ["thread_comment_id"], name: "index_thread_comments_on_thread_comment_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.string "email", limit: 64, null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "what_to_discard_problem_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "parent_comment_id"
    t.string "content", limit: 500, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "what_to_discard_problem_id", null: false
    t.index ["parent_comment_id"], name: "index_what_to_discard_problem_comments_on_parent_comment_id"
    t.index ["user_id"], name: "index_what_to_discard_problem_comments_on_user_id"
    t.index ["what_to_discard_problem_id"], name: "idx_on_what_to_discard_problem_id_8fc9afad9a"
  end

  create_table "what_to_discard_problem_likes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "what_to_discard_problem_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "what_to_discard_problem_id"], name: "idx_on_user_id_what_to_discard_problem_id_1ad936df20", unique: true
    t.index ["user_id"], name: "index_what_to_discard_problem_likes_on_user_id"
    t.index ["what_to_discard_problem_id"], name: "idx_on_what_to_discard_problem_id_6b58ad1bc5"
  end

  create_table "what_to_discard_problems", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "round", null: false
    t.integer "turn", null: false
    t.string "wind", null: false
    t.integer "dora", null: false
    t.integer "point_east", null: false
    t.integer "point_south", null: false
    t.integer "point_west", null: false
    t.integer "point_north", null: false
    t.integer "hand1", null: false
    t.integer "hand2", null: false
    t.integer "hand3", null: false
    t.integer "hand4", null: false
    t.integer "hand5", null: false
    t.integer "hand6", null: false
    t.integer "hand7", null: false
    t.integer "hand8", null: false
    t.integer "hand9", null: false
    t.integer "hand10", null: false
    t.integer "hand11", null: false
    t.integer "hand12", null: false
    t.integer "hand13", null: false
    t.string "tsumo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.index ["user_id"], name: "index_what_to_discard_problems_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "forum_threads", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "thread_comments", "forum_threads"
  add_foreign_key "thread_comments", "thread_comments"
  add_foreign_key "what_to_discard_problem_comments", "what_to_discard_problem_comments", column: "parent_comment_id"
  add_foreign_key "what_to_discard_problem_comments", "what_to_discard_problems"
  add_foreign_key "what_to_discard_problem_likes", "users"
  add_foreign_key "what_to_discard_problem_likes", "what_to_discard_problems"
  add_foreign_key "what_to_discard_problems", "users"
end
