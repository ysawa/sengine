# -*- coding: utf-8 -*-

class ProfileController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :find_user

  # GET /profile/1
  def show
    respond_with(@user)
  end
private
  def find_games
    @games = Game.of_user(@user)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
