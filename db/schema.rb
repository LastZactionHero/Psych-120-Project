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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120104224122) do

  create_table "keywords", :force => true do |t|
    t.string   "original"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "synonyms"
  end

  create_table "questions", :force => true do |t|
    t.string   "study_text"
    t.string   "question_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  create_table "responses", :force => true do |t|
    t.string   "response_type"
    t.integer  "test_period"
    t.integer  "trial"
    t.integer  "study_time"
    t.string   "response"
    t.integer  "recall_reaction_time"
    t.integer  "total_reaction_time"
    t.boolean  "correct"
    t.integer  "keyword_hit_count"
    t.integer  "keyword_miss_count"
    t.integer  "keyword_total_count"
    t.string   "keyword_hits"
    t.string   "keyword_misses"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.integer  "test_id"
    t.integer  "study_user_id"
    t.integer  "keystroke_count"
  end

  create_table "study_users", :force => true do |t|
    t.string   "email_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_meta", :force => true do |t|
    t.integer  "week"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_weeks"
    t.integer  "correct_response_passes"
    t.integer  "study_text_passes"
  end

  create_table "tests", :force => true do |t|
    t.integer  "week"
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_user_id"
    t.string   "condition"
    t.string   "unanswered"
    t.string   "queue"
    t.string   "state"
    t.integer  "trial"
    t.datetime "started_at"
    t.integer  "study_pass"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
