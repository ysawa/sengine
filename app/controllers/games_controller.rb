# -*- coding: utf-8 -*-

class GamesController < ApplicationController
  respond_to :html

  # POST /games
  def create
    @game = Game.new(params[:game])
    if @game.save
      board = Board.new
      board.standardize
      @game.boards << board
      @game.save
      flash[:notice] = "Game successfully created"
      respond_with(@game)
    else
      render :new
    end
  end

  # DELETE /games/1
  def destroy
    @game = Game.find(params[:id])
    flash[:notice] = "Game successfully destroyed." if @game.destroy
    respond_with(@game, :location => games_url)
  end

  # GET /games/1/edit
  def edit
    respond_with(@game = Game.find(params[:id])) do |format|
      format.html { render :action => :edit }
    end
  end

  # GET /games
  def index
    respond_with(@games = Game.all)
  end

  # GET /games/new
  def new
    respond_with(@game = Game.new)
  end

  # GET /games/1
  def show
    respond_with(@game = Game.find(params[:id]))
  end

  # PUT /games/1
  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      flash[:notice] = "Game successfully updated."
      respond_with(@game)
    else
      render :edit
    end
  end
end
