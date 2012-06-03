# -*- coding: utf-8 -*-

class ProfileController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def show
    respond_with(@user)
  end
private
  def find_user
    @user = User.find(params[:id])
  end
end
