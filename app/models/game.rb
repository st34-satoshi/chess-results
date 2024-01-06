# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :white, class_name: 'Player', foreign_key: 'white_id'
  belongs_to :black, class_name: 'Player', foreign_key: 'black_id'
  belongs_to :tournament

  def self.search(param)
    condition = ""
    if param.valid_name?
      condition += "(white.name_en ILIKE '%#{param.name}%' OR white.name_jp ILIKE '%#{param.name}%' OR black.name_en ILIKE '%#{param.name}%' OR black.name_jp ILIKE '%#{param.name}%')"
    end
    if param.valid_tournament?
      if condition.present?
        condition += " AND "
      end
      condition += "(tournaments.name ILIKE '%#{param.tournament}%')"
    end
    if condition.present?
      condition = "WHERE #{condition}"
    end
    Rails.logger.info "condition = #{condition}"

    Game
      .joins("INNER JOIN tournaments ON tournaments.id = games.tournament_id")
      .joins("INNER JOIN players as white ON white.id = games.white_id")
      .joins("INNER JOIN players as black ON black.id = games.black_id #{condition}")
      .select(
        "games.*",
        "tournaments.start_at as date", "tournaments.name as tournament_name",
        "white.name_jp as white_name_jp", "white.name_en as white_name_en",
        "black.name_jp as black_name_jp", "black.name_en as black_name_en"
      )
  end
end
