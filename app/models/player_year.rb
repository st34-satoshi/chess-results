# frozen_string_literal: true

class PlayerYear < ApplicationRecord
  def self.create_player_table(year)
    table_name = "#{year}_players"
    return if ActiveRecord::Base.connection.table_exists? table_name

    ActiveRecord::Migration.create_table table_name do |t|
      t.string :ncs_id, null: false
      t.string :name_en
      t.string :name_jp

      t.integer :total_game_count
      t.integer :total_win_count
      t.integer :total_loss_count
      t.integer :total_draw_count

      t.float :total_opponent_rating_average

      t.timestamps

      t.index(:ncs_id, unique: true)
    end

    py = PlayerYear.find_by(created_year: year)
    return if py.present?

    PlayerYear.create(created_year: year)
  end
end
