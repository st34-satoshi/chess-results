# frozen_string_literal: true

class PlayerYear < ApplicationRecord
  def self.selected_year(year)
    year = year.to_i
    if PlayerYear.find_by(created_year: year).nil?
      year = "すべて" 
    else
      year = "#{year}年"
    end
    year
  end

  def self.valid_year(year)
    year = year.to_i
    year = nil if PlayerYear.find_by(created_year: year).nil?
    year
  end

  def self.years
    years = []
    PlayerYear.order(created_year: "DESC").each do |y|
      years.push "#{y.created_year}年"
    end
    years
  end

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

  def self.update_players(year)
    year_player = Player.clone
    year_player.table_name = "#{year}_players"

    # update players
    d = Date.new(year, 1, 1)
    from_at = d.beginning_of_year
    until_at = d.end_of_year
    Player.all.each do |player|
      total_game_count = Game.games_during(player, from_at, until_at).size
      total_win_count = Game.win_games_during(player, from_at, until_at).size
      total_draw_count = Game.draw_games_during(player, from_at, until_at).size
      total_loss_count = Game.loss_games_during(player, from_at, until_at).size
      opponent_rating_sum = 0
      opponent_rating_count = 0
      Game.white_games_during(player, from_at, until_at).each do |game|
        next if game.black_rating < 400

        opponent_rating_sum += game.black_rating
        opponent_rating_count += 1
      end
      Game.black_games_during(player, from_at, until_at).each do |game|
        next if game.white_rating < 400

        opponent_rating_sum += game.white_rating
        opponent_rating_count += 1
      end
      total_opponent_rating_average = 0.0
      if opponent_rating_count.positive?
        total_opponent_rating_average = opponent_rating_sum / opponent_rating_count.to_f
      end

      # create or update
      p = year_player.find_by(ncs_id: player.ncs_id)
      if p.present?
        p.update(
          total_game_count:,
          total_win_count:,
          total_draw_count:,
          total_loss_count:,
          total_opponent_rating_average:
        )
      else
        year_player.create(
          ncs_id: player.ncs_id,
          name_en: player.name_en,
          name_jp: player.name_jp,
          total_game_count:,
          total_win_count:,
          total_draw_count:,
          total_loss_count:,
          total_opponent_rating_average:
        )
      end
    end
  end
end
