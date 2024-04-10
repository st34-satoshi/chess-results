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

ActiveRecord::Schema[7.1].define(version: 2024_01_04_124847) do
  create_table "games", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "white_id"
    t.integer "white_rating"
    t.integer "white_k"
    t.integer "black_id"
    t.integer "black_rating"
    t.integer "black_k"
    t.float "white_point"
    t.date "start_at"
    t.bigint "tournament_id"
    t.string "time_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_games_on_tournament_id"
  end

  create_table "players", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "ncs_id"
    t.string "name_en"
    t.string "name_jp"
    t.integer "total_game_count"
    t.integer "total_win_count"
    t.integer "total_loss_count"
    t.integer "total_draw_count"
    t.integer "this_year_game_count"
    t.integer "this_year_win_count"
    t.integer "this_year_loss_count"
    t.integer "this_year_draw_count"
    t.integer "last_yaer_game_count"
    t.integer "last_yaer_win_count"
    t.integer "last_yaer_loss_count"
    t.integer "last_yaer_draw_count"
    t.float "total_opponent_rating_average"
    t.float "this_year_opponent_rating_average"
    t.float "last_year_opponent_rating_average"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ncs_id"], name: "index_players_on_ncs_id", unique: true
  end

  create_table "tournaments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "start_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tournaments_on_name"
    t.index ["start_at"], name: "index_tournaments_on_start_at"
  end

  add_foreign_key "games", "tournaments"
end
