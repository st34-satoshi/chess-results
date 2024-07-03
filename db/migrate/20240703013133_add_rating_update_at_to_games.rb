class AddRatingUpdateAtToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :rating_update_at, :date
  end
end
