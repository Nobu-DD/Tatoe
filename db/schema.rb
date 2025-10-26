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

ActiveRecord::Schema[7.2].define(version: 2025_10_21_112656) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_reactions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "answer_id"
    t.bigint "reaction_id"
    t.datetime "published_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_reactions_on_answer_id"
    t.index ["reaction_id"], name: "index_answer_reactions_on_reaction_id"
    t.index ["user_id", "answer_id", "reaction_id"], name: "idx_on_user_id_answer_id_reaction_id_ac9ce2e37f", unique: true
    t.index ["user_id"], name: "index_answer_reactions_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "topic_id"
    t.text "body", null: false
    t.text "reason"
    t.datetime "published_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0
    t.integer "reactions_count", default: 0
    t.integer "empathy_count", default: 0, null: false
    t.integer "consent_count", default: 0, null: false
    t.integer "smile_count", default: 0, null: false
    t.index ["topic_id"], name: "index_answers_on_topic_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "answer_id"
    t.string "body"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_comments_on_answer_id"
    t.index ["user_id", "answer_id"], name: "index_comments_on_user_id_and_answer_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hints", force: :cascade do |t|
    t.bigint "topic_id"
    t.text "body", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_hints_on_topic_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["user_id", "likeable_id", "likeable_type"], name: "index_likes_on_user_id_and_likeable_id_and_likeable_type", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "my_genres", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_my_genres_on_genre_id"
    t.index ["user_id", "genre_id"], name: "index_my_genres_on_user_id_and_genre_id", unique: true
    t.index ["user_id"], name: "index_my_genres_on_user_id"
  end

  create_table "pickups", force: :cascade do |t|
    t.bigint "topic_id"
    t.datetime "start_at", null: false
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_at", "end_at"], name: "index_pickups_on_start_at_and_end_at"
    t.index ["topic_id"], name: "index_pickups_on_topic_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topic_genres", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_topic_genres_on_genre_id"
    t.index ["topic_id", "genre_id"], name: "index_topic_genres_on_topic_id_and_genre_id", unique: true
    t.index ["topic_id"], name: "index_topic_genres_on_topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "user_id"
    t.text "title", null: false
    t.text "description"
    t.datetime "published_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "answers_count", default: 0
    t.integer "likes_count", default: 0
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "avatar"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
