# -*- coding: utf-8 -*-

class GamesController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user_but_introduce_crawler!, only: [:destroy, :edit, :friends, :give_up, :index, :mine, :playing, :update]
  before_filter :authenticate_user_but_pass_crawler!, only: [:check_update, :show]
  before_filter :find_game, only: [:destroy, :edit, :give_up, :show, :update]
  before_filter :append_games_subtitle, only: [:friends, :mine, :playing]

  # GET /games/1/check_update
  def check_update
    @game = Game.where(_id: params[:id]).first # without error
    if @game
      number = @game.boards.count
      @game.check_and_save_if_playing
      if @game.won_user_id == current_user.id
        # only redirect to @game
        render js: "window.location = '#{game_path(@game)}'"
      elsif @game.lost_user_id == current_user.id
        # only redirect to @game
        render js: "window.location = '#{game_path(@game)}'"
      elsif params[:number].to_i < number
        render
      else
        result = 'NO UPDATE'
        render text: result, content_type: Mime::TEXT
      end
    else
      flash[:notice] = t('notices.someone_deleted_this_game')
      render js: "window.location = '/'"
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
      @game.create_facebook_created_feed
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
    respond_with(@games) do |format|
      format.html { render :index }
      format.js { render nothing: true }
    end
  end

  # GET /games/1/edit
  def edit
    respond_with(@game) do |format|
      format.html { render action: :edit }
    end
  end

  # GET /games/friends
  def friends
    @games = Game.of_user_friends(current_user).of_not_user(current_user)
    @games = @games.desc(:created_at).page(params[:page]).per(5)
    respond_with(@games) do |format|
      format.html { render :index }
      format.js { render :index }
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
    @game.finished_at = Time.now
    @game.playing = false
    @game.given_up = true
    if @game.save
      @game.apply_score_changes!
      @game.create_facebook_won_feed
      redirect_to game_path(@game)
    else
      render :show
    end
  end

  # GET /games
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @games = Game.of_user(@user).desc(:created_at).page(params[:page]).per(5)
    else
      @games = Game.all.desc(:created_at).page(params[:page]).per(5)
    end
    respond_with(@games)
  end

  # GET /games/mine
  def mine
    @games = Game.of_user(current_user).desc(:created_at).page(params[:page]).per(5)
    respond_with(@games) do |format|
      format.html { render :index }
      format.js { render :index }
    end
  end

  # GET /games/new
  def new
    @game = Game.new
    respond_with(@game)
  end

  # GET /games/opponent_fields
  def opponent_fields
    @friends = User.facebook_friends(current_user).desc(:used_at)
    render layout: false
  end

  # GET /games/playing
  def playing
    @games = Game.of_user(current_user).playing.desc(:created_at).page(params[:page]).per(5)
    respond_with(@games) do |format|
      format.html { render :index }
      format.js { render :index }
    end
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
  def append_games_subtitle
    @subtitle = [@subtitle, I18n.t('pages.controllers.games.index')]
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def make_game_notice
    make_notice(Game.model_name.human)
  end

  def set_game_players
    begin
      opponent = User.find(params[:game_opponent_id])
      handicap = params[:game_handicap]
      if handicap =~ /(\w+)_(\w+)$/
        handicap_side = $1
        @game.handicap = $2
      else
        handicap_side = nil
      end
      if handicap_side == 'proponent'
        sente = true
      elsif handicap_side == 'opponent'
        sente = false
      else
        case params[:game_order]
        when 'sente'
          sente = true
        when 'gote'
          sente = false
        else
          sente = [true, false].sample
        end
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

  def stringify_grade(grade)
    I18n.t("user.grades.grade_#{grade}")
  end
end
