# frozen_string_literal: true

class CreatePlayerYears < ActiveRecord::Migration[7.1]
  def change
    create_table :player_years do |t|
      t.integer :created_year

      t.timestamps
    end
  end
end
