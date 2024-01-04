class Player < ApplicationRecord
  has_many :white_games, class_name: "Game", foreign_key: "white_id"
  has_many :black_games, class_name: "Game", foreign_key: "black_id"
end
