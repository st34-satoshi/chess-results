class PlayersController < ApplicationController
  def index
    @players = Player.all.limit(100)
  end

  def show
    set_player
  end

  private

  def set_player
    @player = Player.find_by(ncs_id: params[:id])
  end
end
