# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action lambda  {
    set_header_page('players')
  }

  def index
    @kind = Player.valid_ranking_kind(params[:kind])
    @year = PlayerYear.valid_year(params[:year])
    @players = Player.ranking(@kind, @year)
  end

  def show
    set_player
    return if @player

    flash[:warning] = 'プレーヤーが見つかりませんでした。'
    redirect_to players_path
    nil
  end

  private

  def set_player
    @player = Player.find_by(ncs_id: params[:id])
  end
end
