class AddRoundToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :round, :integer
  end
end
