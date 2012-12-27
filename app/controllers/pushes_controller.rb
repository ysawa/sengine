# -*- coding: utf-8 -*-

class PushesController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!

  def index
    @pushes = current_user.created_pushes.page(params[:page])
    respond_with(@pushes)
  end
end
