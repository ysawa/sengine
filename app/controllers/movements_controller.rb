# -*- coding: utf-8 -*-

class MovementsController < ApplicationController
  respond_to :html, :js, :json
  before_filter :authenticate_user_but_introduce_crawler!
  before_filter :find_game

  # POST /games/1/movements
  def create
    if @game.check_if_playing
      @movement = Movement.new(params[:movement])
      @movement.game = @game
      @game.make_board_from_movement!(@movement)
      respond_to do |format|
        format.js { render text: 'OK', content_type: Mime::TEXT }
        format.html { redirect_to game_path(@game) }
      end
    else
      raise Game::CannotTakeMovement.new 'game is not being played now'
    end
  rescue => error
    respond_to do |format|
      format.js { render text: 'NG', content_type: Mime::TEXT }
      format.html { redirect_to game_path(@game) }
    end
  end

private
  def find_game
    @game = Game.find(params[:game_id])
  end
end
