# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :white_id
      t.integer :white_rating
      t.integer :white_k
      t.string :black_id
      t.string :black_rating
      t.integer :black_k
      t.integer :white_point
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end
end
