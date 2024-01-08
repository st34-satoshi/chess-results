class PlayersController < ApplicationController
  before_action ->{
    set_header_page("players")
  }

  def index
    @kind = params[:kind]
    @kind ||= "games"
    @players = Player.ranking(@kind)
  end

  def show
    set_player
  end

  private

  def set_player
    @player = Player.find_by(ncs_id: params[:id])
  end
end
