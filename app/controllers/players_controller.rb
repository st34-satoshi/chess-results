class PlayersController < ApplicationController
  def show
    set_player
  end

  private

  def set_player
    @player = Player.find_by(ncs_id: params[:id])
  end
end
