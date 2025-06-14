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

ActiveRecord::Schema[7.2].define(version: 2025_06_14_040052) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "authorizations", force: :cascade do |t|
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likable_type", null: false
    t.bigint "likable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "tiles", force: :cascade do |t|
    t.integer "suit", null: false
    t.integer "ordinal_number_in_suit", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 20, null: false
    t.string "email", limit: 64, null: false
    t.string "password_digest", null: false
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "what_to_discard_problem_comments", force: :cascade do |t|
    t.bigint "what_to_discard_problem_id", null: false
    t.bigint "user_id", null: false
    t.bigint "parent_comment_id"
    t.string "content", limit: 500, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_comment_id"], name: "index_what_to_discard_problem_comments_on_parent_comment_id"
    t.index ["user_id"], name: "index_what_to_discard_problem_comments_on_user_id"
    t.index ["what_to_discard_problem_id"], name: "idx_on_what_to_discard_problem_id_8fc9afad9a"
  end

  create_table "what_to_discard_problem_votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tile_id", null: false
    t.bigint "what_to_discard_problem_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tile_id"], name: "index_what_to_discard_problem_votes_on_tile_id"
    t.index ["user_id", "what_to_discard_problem_id"], name: "idx_on_user_id_what_to_discard_problem_id_ba7da3c2b5", unique: true
    t.index ["user_id"], name: "index_what_to_discard_problem_votes_on_user_id"
    t.index ["what_to_discard_problem_id"], name: "idx_on_what_to_discard_problem_id_619294c3a6"
  end

  create_table "what_to_discard_problems", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "round", null: false
    t.integer "turn", null: false
    t.string "wind", null: false
    t.integer "point_east", null: false
    t.integer "point_south", null: false
    t.integer "point_west", null: false
    t.integer "point_north", null: false
    t.bigint "dora_id", null: false
    t.bigint "hand1_id", null: false
    t.bigint "hand2_id", null: false
    t.bigint "hand3_id", null: false
    t.bigint "hand4_id", null: false
    t.bigint "hand5_id", null: false
    t.bigint "hand6_id", null: false
    t.bigint "hand7_id", null: false
    t.bigint "hand8_id", null: false
    t.bigint "hand9_id", null: false
    t.bigint "hand10_id", null: false
    t.bigint "hand11_id", null: false
    t.bigint "hand12_id", null: false
    t.bigint "hand13_id", null: false
    t.bigint "tsumo_id", null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "votes_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dora_id"], name: "index_what_to_discard_problems_on_dora_id"
    t.index ["hand10_id"], name: "index_what_to_discard_problems_on_hand10_id"
    t.index ["hand11_id"], name: "index_what_to_discard_problems_on_hand11_id"
    t.index ["hand12_id"], name: "index_what_to_discard_problems_on_hand12_id"
    t.index ["hand13_id"], name: "index_what_to_discard_problems_on_hand13_id"
    t.index ["hand1_id"], name: "index_what_to_discard_problems_on_hand1_id"
    t.index ["hand2_id"], name: "index_what_to_discard_problems_on_hand2_id"
    t.index ["hand3_id"], name: "index_what_to_discard_problems_on_hand3_id"
    t.index ["hand4_id"], name: "index_what_to_discard_problems_on_hand4_id"
    t.index ["hand5_id"], name: "index_what_to_discard_problems_on_hand5_id"
    t.index ["hand6_id"], name: "index_what_to_discard_problems_on_hand6_id"
    t.index ["hand7_id"], name: "index_what_to_discard_problems_on_hand7_id"
    t.index ["hand8_id"], name: "index_what_to_discard_problems_on_hand8_id"
    t.index ["hand9_id"], name: "index_what_to_discard_problems_on_hand9_id"
    t.index ["tsumo_id"], name: "index_what_to_discard_problems_on_tsumo_id"
    t.index ["user_id"], name: "index_what_to_discard_problems_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "likes", "users"
  add_foreign_key "what_to_discard_problem_comments", "users"
  add_foreign_key "what_to_discard_problem_comments", "what_to_discard_problem_comments", column: "parent_comment_id"
  add_foreign_key "what_to_discard_problem_comments", "what_to_discard_problems"
  add_foreign_key "what_to_discard_problem_votes", "tiles"
  add_foreign_key "what_to_discard_problem_votes", "users"
  add_foreign_key "what_to_discard_problem_votes", "what_to_discard_problems"
  add_foreign_key "what_to_discard_problems", "tiles", column: "dora_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand10_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand11_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand12_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand13_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand1_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand2_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand3_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand4_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand5_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand6_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand7_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand8_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "hand9_id"
  add_foreign_key "what_to_discard_problems", "tiles", column: "tsumo_id"
  add_foreign_key "what_to_discard_problems", "users"
end
