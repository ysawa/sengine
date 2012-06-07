# -*- coding: utf-8 -*-

class GamesController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user!
  before_filter :find_game, only: [:check_update, :destroy, :edit, :give_up, :show, :update]

  # GET /games/1/check_update
  def check_update
    number = @game.boards.count
    @game.check_if_playing!
    if @game.won_user == current_user
      flash[:notice] = t('notices.you_won')
      # only redirect to @game
      render js: "window.location = '#{game_path(@game)}'"
    elsif @game.lost_user == current_user
      flash[:notice] = t('notices.you_lost')
      # only redirect to @game
      render js: "window.location = '#{game_path(@game)}'"
    elsif params[:number].to_i < number
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
    if set_game_players && @game.save
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

  # PUT /games/1/give_up
  def give_up
    if current_user == @game.sente_user
      @game.won_user = @game.gote_user
      @game.lost_user = @game.sente_user
    else
      @game.lost_user = @game.gote_user
      @game.won_user = @game.sente_user
    end
    @game.playing = false
    if @game.save
      redirect_to game_path(@game)
    else
      render :show
    end
  end

  # GET /games
  def index
    @games = Game.all.desc(:created_at).page(params[:page])
    respond_with(@games)
  end

  # GET /games/new
  def new
    @game = Game.new
    respond_with(@game)
  end

  # GET /games/1
  def show
    if params[:number].present?
      @board = @game.boards.where(number: params[:number].to_i).first
    else
      @board = @game.boards.last
    end
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

  def set_game_players
    begin
      opponent = User.find(params[:game_opponent_id])
      case params[:game_order]
      when 'sente'
        sente = true
      when 'gote'
        sente = false
      else
        sente = [true, false].sample
      end
      if sente
        @game.sente_user = current_user
        @game.gote_user = opponent
      else
        @game.sente_user = opponent
        @game.gote_user = current_user
      end
    rescue
      return false
    end
    true
  end
end
