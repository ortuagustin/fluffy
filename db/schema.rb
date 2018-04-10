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

ActiveRecord::Schema.define(version: 20180410195150) do

  create_table "courses", force: :cascade do |t|
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "students_count", default: 0
    t.index ["year"], name: "index_courses_on_year", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "course_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "replies_count", default: 0
    t.boolean "is_sticky", default: false, null: false
    t.integer "best_reply_id"
    t.index ["best_reply_id"], name: "index_posts_on_best_reply_id"
    t.index ["course_id"], name: "index_posts_on_course_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "replies", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_replies_on_post_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "dni"
    t.string "email"
    t.string "file_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.index ["course_id"], name: "index_students_on_course_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "subscriber_id"
    t.integer "subscribable_id"
    t.string "subscribable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriber_id", "subscribable_id", "subscribable_type"], name: "unique_subscription_index", unique: true
  end

  create_table "test_results", force: :cascade do |t|
    t.integer "test_id"
    t.integer "student_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_test_results_on_student_id"
    t.index ["test_id", "student_id"], name: "index_test_results_on_test_id_and_student_id", unique: true
    t.index ["test_id"], name: "index_test_results_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "title"
    t.datetime "evaluated_at"
    t.integer "passing_score"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_tests_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

end
