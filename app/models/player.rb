# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :white_games, class_name: 'Game', foreign_key: 'white_id'
  has_many :black_games, class_name: 'Game', foreign_key: 'black_id'

  def to_param
    ncs_id
  end
end
