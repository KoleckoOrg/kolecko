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

ActiveRecord::Schema.define(version: 20190906160035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "correct"
    t.bigint "solution_id"
    t.bigint "visit_id"
    t.index ["solution_id"], name: "index_answers_on_solution_id"
    t.index ["visit_id"], name: "index_answers_on_visit_id"
  end

  create_table "hint_requests", force: :cascade do |t|
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bounty"
    t.boolean "cancelled", default: false, null: false
    t.boolean "closed", default: false, null: false
    t.bigint "visit_id"
    t.index ["visit_id"], name: "index_hint_requests_on_visit_id"
  end

  create_table "hints", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "hint_request_id"
    t.string "text"
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "opened"
    t.integer "rating"
    t.index ["hint_request_id"], name: "index_hints_on_hint_request_id"
    t.index ["team_id"], name: "index_hints_on_team_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ocoin_transactions", force: :cascade do |t|
    t.integer "points"
    t.text "message"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.bigint "type"
    t.bigint "team_id"
  end

  create_table "puzzles", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "opens_at"
    t.datetime "closes_at"
    t.integer "points"
    t.integer "puztype"
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "puzzle_id"
    t.string "text"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puzzle_id"], name: "index_solutions_on_puzzle_id"
  end

  create_table "team_messages", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "message_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_team_messages_on_message_id"
    t.index ["team_id"], name: "index_team_messages_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "phone"
    t.boolean "payed", default: false, null: false
    t.string "player1_name"
    t.string "player1_email"
    t.string "player2_name"
    t.string "player2_email"
    t.string "player3_name"
    t.string "player3_email"
    t.string "player4_name"
    t.string "player4_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "points", default: 0
    t.boolean "admin", default: false, null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["reset_password_token"], name: "index_teams_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "puzzle_id"
    t.integer "wrong_answers", default: 0
    t.datetime "solved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puzzle_id"], name: "index_visits_on_puzzle_id"
    t.index ["team_id", "puzzle_id"], name: "index_visits_on_team_id_and_puzzle_id", unique: true
    t.index ["team_id"], name: "index_visits_on_team_id"
  end

  add_foreign_key "answers", "solutions"
  add_foreign_key "answers", "visits"
  add_foreign_key "hint_requests", "visits"
  add_foreign_key "solutions", "puzzles"
  add_foreign_key "team_messages", "messages"
  add_foreign_key "team_messages", "teams"
  add_foreign_key "visits", "puzzles"
  add_foreign_key "visits", "teams"
end
