class ResultsController < ApplicationController
  def index
    @search_parameter = search_params
  end

  private

  def search_params
    GameSearchParameter.new(params.fetch(:game_search_parameter, {}))
  end
end
