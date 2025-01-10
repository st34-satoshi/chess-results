class AddChangeToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :white_change, :decimal, precision: 10, scale: 3
    add_column :games, :black_change, :decimal, precision: 10, scale: 3
  end
end
