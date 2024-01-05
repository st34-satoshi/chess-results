# frozen_string_literal: true

class CreateTournaments < ActiveRecord::Migration[7.1]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :start_at

      t.timestamps
    end
    add_index :tournaments, :name, unique: false
    add_index :tournaments, :start_at, unique: false
  end
end
