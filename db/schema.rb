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

ActiveRecord::Schema.define(version: 20170117032539) do

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

  create_table "blades_armors", force: :cascade do |t|
    t.string   "name",         limit: 20,                 null: false
    t.boolean  "used",                    default: false, null: false
    t.integer  "character_id",                            null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["character_id"], name: "index_blades_armors_on_character_id", using: :btree
  end

  create_table "blades_characters", force: :cascade do |t|
    t.string   "name",               limit: 50,                 null: false
    t.string   "playbook",           limit: 20
    t.string   "aka",                limit: 50
    t.text     "look"
    t.text     "heritage"
    t.text     "background"
    t.text     "vice"
    t.integer  "stress",             limit: 2,  default: 0,     null: false
    t.string   "trauma",             limit: 50, default: "",    null: false
    t.boolean  "healing_unlocked",              default: false, null: false
    t.integer  "healing_clock",      limit: 2,  default: 0,     null: false
    t.string   "harm_severe",        limit: 30, default: "",    null: false
    t.string   "harm_moderate1",     limit: 30, default: "",    null: false
    t.string   "harm_moderate2",     limit: 30, default: "",    null: false
    t.string   "harm_lesser1",       limit: 30, default: "",    null: false
    t.string   "harm_lesser2",       limit: 30, default: "",    null: false
    t.boolean  "armor_normal",                  default: false, null: false
    t.boolean  "armor_heavy",                   default: false, null: false
    t.integer  "playbook_xp",        limit: 2,  default: 0,     null: false
    t.integer  "hunt",               limit: 2,  default: 0,     null: false
    t.integer  "study",              limit: 2,  default: 0,     null: false
    t.integer  "survey",             limit: 2,  default: 0,     null: false
    t.integer  "tinker",             limit: 2,  default: 0,     null: false
    t.integer  "finesse",            limit: 2,  default: 0,     null: false
    t.integer  "prowl",              limit: 2,  default: 0,     null: false
    t.integer  "skirmish",           limit: 2,  default: 0,     null: false
    t.integer  "wreck",              limit: 2,  default: 0,     null: false
    t.integer  "attune",             limit: 2,  default: 0,     null: false
    t.integer  "command",            limit: 2,  default: 0,     null: false
    t.integer  "consort",            limit: 2,  default: 0,     null: false
    t.integer  "sway",               limit: 2,  default: 0,     null: false
    t.integer  "insight_xp",         limit: 2,  default: 0,     null: false
    t.integer  "prowess_xp",         limit: 2,  default: 0,     null: false
    t.integer  "resolve_xp",         limit: 2,  default: 0,     null: false
    t.integer  "coin",               limit: 2,  default: 0,     null: false
    t.integer  "stash",              limit: 2,  default: 0,     null: false
    t.integer  "load",               limit: 2,  default: 3,     null: false
    t.text     "notes"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "edit_permission_id"
    t.integer  "view_permission_id"
    t.uuid     "game_id",                                       null: false
    t.text     "special_abilities",             default: [],    null: false, array: true
    t.text     "items",                         default: [],    null: false, array: true
    t.index ["edit_permission_id"], name: "index_blades_characters_on_edit_permission_id", using: :btree
    t.index ["game_id"], name: "index_blades_characters_on_game_id", using: :btree
    t.index ["view_permission_id"], name: "index_blades_characters_on_view_permission_id", using: :btree
  end

  create_table "blades_strange_friends", force: :cascade do |t|
    t.string   "name",         limit: 50, null: false
    t.string   "title",        limit: 50, null: false
    t.text     "description"
    t.boolean  "is_friend"
    t.integer  "character_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["character_id"], name: "index_blades_strange_friends_on_character_id", using: :btree
  end

  create_table "chats", force: :cascade do |t|
    t.integer  "player_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "permission_id"
    t.index ["permission_id"], name: "index_chats_on_permission_id", using: :btree
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

  create_table "logs", force: :cascade do |t|
    t.integer  "chat_id",    null: false
    t.string   "message",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_logs_on_chat_id", using: :btree
  end

  create_table "permissions", force: :cascade do |t|
    t.text "value", null: false
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
