# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :white_games, class_name: 'Game', foreign_key: 'white_id'
  has_many :black_games, class_name: 'Game', foreign_key: 'black_id'

  def to_param
    ncs_id
  end

  def self.ranking(kind)
    return Player.order(total_game_count: :desc).limit(100) if kind == "games"
    return Player.order(total_win_count: :desc).limit(100) if kind == "win"
    return Player.order(total_draw_count: :desc).limit(100) if kind == "draw"
    return Player.order(total_opponent_rating_average: :desc).limit(100) if kind == "rating"
    Player.all.limit(100)
  end

  def ranking_value(kind)
    return total_game_count if kind == "games"
    return total_win_count if kind == "win"
    return total_draw_count if kind == "draw"
    return total_opponent_rating_average.round(1) if kind == "rating"
    ""
  end

  def games
    white_games + black_games
  end

  def games_of(time_type)
    games.select {|game| game.time_type == time_type}
  end

  def win_games_of(time_type)
    white_games.select {|game| game.time_type == time_type && game.white_point == 1} + black_games.select {|game| game.time_type == time_type && game.white_point == 0}
  end

  def loss_games_of(time_type)
    white_games.select {|game| game.time_type == time_type && game.white_point == 0} + black_games.select {|game| game.time_type == time_type && game.white_point == 1}
  end

  def draw_games_of(time_type)
    games.select {|game| game.time_type == time_type && game.white_point == 0.5}
  end

  def color_games_of(time_type, color)
    color_games = color == "White" ? white_games : black_games
    color_games.select {|game| game.time_type == time_type}
  end

  def color_win_games_of(time_type, color)
    color_games = color == "White" ? white_games : black_games
    p = color == "White" ? 1 : 0
    color_games.select {|game| game.time_type == time_type && game.white_point == p}
  end

  def color_loss_games_of(time_type, color)
    color_games = color == "White" ? white_games : black_games
    p = color == "White" ? 0 : 1
    color_games.select {|game| game.time_type == time_type && game.white_point == p}
  end

  def color_draw_games_of(time_type, color)
    color_games = color == "White" ? white_games : black_games
    color_games.select {|game| game.time_type == time_type && game.white_point == 0.5}
  end
end
