# -*- coding: utf-8 -*-

class Sys::GamesController < Sys::ApplicationController
  respond_to :html
  before_filter :find_games
  before_filter :find_game, only: %w(destroy edit set_admin show unset_admin udpate)

  # GET /setting/edit
  def edit
    respond_with(@game)
  end

  def index
    @games = @games.page(params[:page])
  end

  # GET /setting
  def show
    respond_with(@game)
  end

  # PUT /setting
  def update
    if @game.update_attributes(params[:game])
      respond_with(@game, location: sys_game_path(@game))
    else
      render :edit
    end
  end

private

  def find_game
    @game = @games.find(params[:id])
  end

  def find_games
    @games = Game.all
  end
end
