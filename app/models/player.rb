# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :white_games, class_name: 'Game', foreign_key: 'white_id'
  has_many :black_games, class_name: 'Game', foreign_key: 'black_id'

  attribute :ranking_kind, :string
  enum ranking_kind: { games: 'games', win: 'win', draw: 'draw', avg_rating: 'avg_rating' }, _prefix: true

  def to_param
    ncs_id
  end

  def self.valid_ranking_kind(kind)
    return kind if Player.ranking_kinds.values.include? kind

    Player.ranking_kinds[:games]
  end

  def self.ranking(kind)
    return Player.order(total_win_count: :desc).limit(100) if kind == Player.ranking_kinds[:win]
    return Player.order(total_draw_count: :desc).limit(100) if kind == Player.ranking_kinds[:draw]
    return Player.order(total_opponent_rating_average: :desc).limit(100) if kind == Player.ranking_kinds[:avg_rating]

    Player.order(total_game_count: :desc).limit(100) if kind == Player.ranking_kinds[:games] # default is :games
  end

  def ranking_value(kind)
    return total_game_count if kind == Player.ranking_kinds[:games]
    return total_win_count if kind == Player.ranking_kinds[:win]
    return total_draw_count if kind == Player.ranking_kinds[:draw]
    return total_opponent_rating_average.round(1) if kind == Player.ranking_kinds[:avg_rating]

    ''
  end

  def games
    white_games + black_games
  end

  def games_of(time_type)
    games.select { |game| game.time_type == time_type }
  end

  # rubocop:disable Layout/LineLength
  def win_games_of(time_type)
    white_games.select { |game| game.time_type == time_type && game.white_point == 1 } + black_games.select do |game|
                                                                                           game.time_type == time_type && game.white_point.zero?
                                                                                         end
  end

  def loss_games_of(time_type)
    white_games.select { |game| game.time_type == time_type && game.white_point.zero? } + black_games.select do |game|
                                                                                            game.time_type == time_type && game.white_point == 1
                                                                                          end
  end
  # rubocop:enable Layout/LineLength

  def draw_games_of(time_type)
    games.select { |game| game.time_type == time_type && game.white_point.to_d == 0.5.to_d }
  end

  def color_games_of(time_type, color)
    color_games = color == 'White' ? white_games : black_games
    color_games.select { |game| game.time_type == time_type }
  end

  def color_win_games_of(time_type, color)
    color_games = color == 'White' ? white_games : black_games
    p = color == 'White' ? 1 : 0
    color_games.select { |game| game.time_type == time_type && game.white_point == p }
  end

  def color_loss_games_of(time_type, color)
    color_games = color == 'White' ? white_games : black_games
    p = color == 'White' ? 0 : 1
    color_games.select { |game| game.time_type == time_type && game.white_point == p }
  end

  def color_draw_games_of(time_type, color)
    color_games = color == 'White' ? white_games : black_games
    color_games.select { |game| game.time_type == time_type && game.white_point.to_d == 0.5.to_d }
  end
end
