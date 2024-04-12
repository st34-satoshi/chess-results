# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action lambda  {
    set_header_page('players')
  }

  def index
    @kind = Player.valid_ranking_kind(params[:kind])
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
