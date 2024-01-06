# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :white, class_name: 'Player', foreign_key: 'white_id'
  belongs_to :black, class_name: 'Player', foreign_key: 'black_id'
  belongs_to :tournament

  def self.search(param)
    Game
      .joins("INNER JOIN players as white ON white.id = games.white_id")
      .joins("INNER JOIN players as black ON black.id = games.black_id WHERE white.name_en ILIKE '%Yama%'")
      .select("games.*", "white.name_jp as white_name_jp", "black.name_jp as black_name_jp")
  end
end
