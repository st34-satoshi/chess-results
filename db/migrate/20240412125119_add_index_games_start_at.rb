class AddIndexGamesStartAt < ActiveRecord::Migration[7.1]
  def change
    add_index :games, :start_at
  end
end
