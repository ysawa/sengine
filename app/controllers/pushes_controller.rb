# -*- coding: utf-8 -*-

class PushesController < ApplicationController
  respond_to :json

  def index
    @pushes = []
    respond_with(@pushes)
  end
end
