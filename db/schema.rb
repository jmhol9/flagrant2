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

ActiveRecord::Schema.define(version: 20170308141320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "tournament_id", null: false
    t.float    "points",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id"], name: "index_entries_on_user_id", using: :btree
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "team_id",    null: false
    t.integer  "entry_id",   null: false
    t.integer  "round_id",   null: false
    t.float    "points",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_picks_on_entry_id", using: :btree
    t.index ["round_id"], name: "index_picks_on_round_id", using: :btree
    t.index ["team_id"], name: "index_picks_on_team_id", using: :btree
  end

  create_table "results", force: :cascade do |t|
    t.integer  "round_id",   null: false
    t.integer  "team_id",    null: false
    t.boolean  "win",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_results_on_round_id", using: :btree
    t.index ["team_id"], name: "index_results_on_team_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.string   "name",               null: false
    t.integer  "tournament_id",      null: false
    t.integer  "dependent_round_id"
    t.datetime "picks_start",        null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "picks_close",        null: false
    t.index ["dependent_round_id"], name: "index_rounds_on_dependent_round_id", using: :btree
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "seed",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "entry_fee"
    t.float    "allowance"
  end

  create_table "updates", force: :cascade do |t|
    t.string   "title",      null: false
    t.text     "body",       null: false
    t.integer  "author_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_updates_on_author_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "team_name"
    t.string   "password_digest"
    t.string   "session_token"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name",                            null: false
    t.string   "city"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
