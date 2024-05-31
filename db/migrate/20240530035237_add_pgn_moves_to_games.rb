class AddPgnMovesToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :pgn_moves, :text
  end
end
