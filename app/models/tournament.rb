# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :games
end
