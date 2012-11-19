# -*- coding: utf-8 -*-

class GamesController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user_but_introduce_crawler!, only: [:create, :destroy, :edit, :friends, :give_up, :index, :mine, :new, :playing, :update]
  before_filter :authenticate_user_but_pass_crawler!, only: [:check_update, :show]
  before_filter :find_game, only: [:destroy, :edit, :give_up, :show, :update]
  before_filter :append_games_subtitle, only: [:friends, :mine, :playing]

  # GET /games/1/check_update
  def check_update
    @game = Game.where(_id: params[:id]).first # without error
    if @game
      number = @game.number
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
      @game.create_first_board
      make_game_notice
      @game.async_deliver_created_notices
      opponent = @game.opponent(current_user)
      if opponent.bot? && @game.sente_user_id == opponent.id
        opponent.async_process_next_movement(@game)
      end
      respond_with(@game)
    else
      make_subtitle :new
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
    if params[:page].blank? || params[:page].to_i == 1
      current_user.update_friend_ids
    end
    @games = Game.of_user_friends(current_user).of_not_user(current_user)
    @games = @games.desc(:created_at).page(params[:page]).per(5)
    respond_with(@games) do |format|
      format.html { render :index }
      format.js { render :index }
    end
  end

  # PUT /games/1/give_up
  def give_up
    if @game.give_up!(current_user)
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
    current_user.update_friend_ids
    @friends = User.friends(current_user).desc(:used_at).to_a
    bot = MinnaBot.first
    @friends.prepend bot if bot
    render layout: false
  end

  # GET /games/playing
  def playing
    @games = Game.of_user(current_user).playing.desc(:updated_at).page(params[:page]).per(5)
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
      order = params[:game_order]
      @game.set_players_from_order_and_handicap(current_user, opponent, order, handicap)
    rescue => error
      Rails.logger.error error
      return false
    end
    true
  end

  def stringify_grade(grade)
    I18n.t("user.grades.grade_#{grade}")
  end
end
