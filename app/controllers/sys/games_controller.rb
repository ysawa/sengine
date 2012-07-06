# -*- coding: utf-8 -*-

class Sys::GamesController < Sys::ApplicationController
  respond_to :html, :js
  before_filter :find_games
  before_filter :find_game, only: %w(destroy edit set_admin show unset_admin udpate)

  # GET /sys/games/edit
  def edit
    respond_with(@game)
  end

  # GET /sys/games
  def index
    @games = @games.desc(:created_at).page(params[:page])
  end

  # GET /sys/games/1
  def show
    if params[:number].present?
      @board = @game.boards.where(number: params[:number].to_i).first
    else
      @board = @game.boards.last
    end
    respond_with(@game)
  end

  # PUT /sys/games
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
