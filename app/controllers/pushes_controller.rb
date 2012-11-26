# -*- coding: utf-8 -*-

class PushesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def index
    @pushes = current_user.created_pushes.to_a
    respond_with(@pushes)
  end
end
