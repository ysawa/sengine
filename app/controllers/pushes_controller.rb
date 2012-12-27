# -*- coding: utf-8 -*-

class PushesController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  def index
    @pushes = Push.shown(current_user).page(params[:page])
    respond_with(@pushes)
  end
end
