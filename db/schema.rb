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

ActiveRecord::Schema.define(version: 20161020022903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "auths", force: :cascade do |t|
    t.integer  "provider",   default: 0, null: false
    t.string   "uid",                    null: false
    t.string   "name",                   null: false
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["uid", "provider"], name: "index_auths_on_uid_and_provider", using: :btree
    t.index ["user_id"], name: "index_auths_on_user_id", using: :btree
  end

  create_table "chats", force: :cascade do |t|
    t.integer  "player_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_chats_on_player_id", using: :btree
  end

  create_table "dice", force: :cascade do |t|
    t.integer  "roll_id",    null: false
    t.integer  "kind",       null: false
    t.integer  "result",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roll_id"], name: "index_dice_on_roll_id", using: :btree
  end

  create_table "games", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "game_type",   null: false
    t.integer  "max_players"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer  "user_id"
    t.uuid     "game_id"
    t.string   "name"
    t.boolean  "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id", using: :btree
    t.index ["user_id"], name: "index_players_on_user_id", using: :btree
  end

  create_table "rolls", force: :cascade do |t|
    t.integer  "chat_id",                null: false
    t.integer  "bonus",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["chat_id"], name: "index_rolls_on_chat_id", using: :btree
  end

  create_table "talks", force: :cascade do |t|
    t.integer  "chat_id",    null: false
    t.string   "message",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_talks_on_chat_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.integer  "primary_auth_id",     null: false
    t.datetime "earliest_token_time", null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["primary_auth_id"], name: "index_users_on_primary_auth_id", using: :btree
  end

end
