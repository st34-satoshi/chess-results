# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :ncs_id
      t.string :name_en
      t.string :name_jp

      t.integer :total_game_count
      t.integer :total_win_count
      t.integer :total_loss_count
      t.integer :total_draw_count
      t.integer :this_year_game_count
      t.integer :this_year_win_count
      t.integer :this_year_loss_count
      t.integer :this_year_draw_count
      t.integer :last_yaer_game_count
      t.integer :last_yaer_win_count
      t.integer :last_yaer_loss_count
      t.integer :last_yaer_draw_count

      t.float :total_opponent_rating_average
      t.float :this_year_opponent_rating_average
      t.float :last_year_opponent_rating_average

      t.timestamps
    end
    add_index :players, :ncs_id, unique: true
  end
end
