# -*- coding: utf-8 -*-

class GamesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :find_game, only: [:check_update, :destroy, :edit, :show, :update]

  # GET /games/1/check_update
  def check_update
    number = @game.boards.count
    if params[:number].to_i < number
      render
    else
      result = 'NO UPDATE'
      render text: result, content_type: Mime::TEXT
    end
  end

  # POST /games
  def create
    @game = Game.new(params[:game])
    @game.author = current_user
    if @game.save
      @game.boards << Board.hirate
      @game.save
      make_game_notice
      respond_with(@game)
    else
      render :new
    end
  end

  # DELETE /games/1
  def destroy
    if @game.destroy
      make_game_notice
    end
    respond_with(@game, location: games_path)
  end

  # GET /games/1/edit
  def edit
    respond_with(@game) do |format|
      format.html { render action: :edit }
    end
  end

  # GET /games
  def index
    @games = Game.all
    respond_with(@games)
  end

  # GET /games/new
  def new
    @game = Game.new
    respond_with(@game)
  end

  # GET /games/1
  def show
    respond_with(@game)
  end

  # PUT /games/1
  def update
    if @game.update_attributes(params[:game])
      make_game_notice
      respond_with(@game)
    else
      render :edit
    end
  end

private
  def find_game
    @game = Game.find(params[:id])
  end

  def make_game_notice
    make_notice(Game.model_name.human)
  end
end
