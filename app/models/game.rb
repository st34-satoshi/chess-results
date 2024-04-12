# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :white, class_name: 'Player', foreign_key: 'white_id'
  belongs_to :black, class_name: 'Player', foreign_key: 'black_id'
  belongs_to :tournament

  validates :time_type, inclusion: { in: %w[ST RP] }
  validate :valid_white_point?

  def valid_white_point?
    return false if [1, 0.5, 0].include? white_point

    errors.add(:white_point, 'not the valid number, 0, 0.5 or 1')
  end

  def self.games_during(player, from_at, until_at)
    Game.where(white_id: player.id).or(Game.where(black_id: player.id)).where("start_at >= ?", from_at).where("start_at <= ?", until_at)
  end

  def self.win_games_during(player, from_at, until_at)
    Game.where(white_id: player.id).where(white_point: 1).or(Game.where(black_id: player.id).where(white_point: 0)).where("start_at >= ?", from_at).where("start_at <= ?", until_at)
  end

  def self.draw_games_during(player, from_at, until_at)
    Game.where(white_id: player.id).or(Game.where(black_id: player.id)).where(white_point: 0).where("start_at >= ?", from_at).where("start_at <= ?", until_at)
  end

  def self.loss_games_during(player, from_at, until_at)
    Game.where(white_id: player.id).where(white_point: 0).or(Game.where(black_id: player.id).where(white_point: 1)).where("start_at >= ?", from_at).where("start_at <= ?", until_at)
  end

  def self.white_games_during(player, from_at, until_at)
    Game.where(white_id: player.id).where("start_at >= ?", from_at).where("start_at <= ?", until_at)
  end

  def self.black_games_during(player, from_at, until_at)
    Game.where(black_id: player.id).where("start_at >= ?", from_at).where("start_at <= ?", until_at)
  end

  def self.search(param)
    condition = ''
    # rubocop:disable Layout/LineLength
    if param.valid_name?
      condition += "(white.name_en LIKE '%#{param.name}%' OR white.name_jp LIKE '%#{param.name}%' OR black.name_en LIKE '%#{param.name}%' OR black.name_jp LIKE '%#{param.name}%')"
    end
    # rubocop:enable Layout/LineLength
    if param.valid_tournament?
      condition += ' AND ' if condition.present?
      condition += "(tournaments.name LIKE '%#{param.tournament}%')"
    end
    if param.date_from.present?
      condition += ' AND ' if condition.present?
      condition += "(tournaments.start_at >= '#{param.date_from}')"
    end
    if param.date_until.present?
      condition += ' AND ' if condition.present?
      condition += "(tournaments.start_at <= '#{param.date_until}')"
    end
    condition = "WHERE #{condition}" if condition.present?
    Rails.logger.info "condition = #{condition}"

    Game
      .joins('INNER JOIN tournaments ON tournaments.id = games.tournament_id')
      .joins('INNER JOIN players as white ON white.id = games.white_id')
      .joins("INNER JOIN players as black ON black.id = games.black_id #{condition}")
      .select(
        'games.*',
        'tournaments.start_at as date', 'tournaments.name as tournament_name',
        'white.name_jp as white_name_jp', 'white.name_en as white_name_en', 'white.ncs_id as white_ncs_id',
        'black.name_jp as black_name_jp', 'black.name_en as black_name_en', 'black.ncs_id as black_ncs_id'
      )
      .order(date: :desc)
  end
end
