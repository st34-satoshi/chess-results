# frozen_string_literal: true

class ResultsController < ApplicationController
  def index
    @search_parameter = search_params
    @games = Game.search(@search_parameter)
  end

  private

  def search_params
    GameSearchParameter.new(params.fetch(:game_search_parameter, {}))
  end
end
