# -*- coding: utf-8 -*-

class AboutController < ApplicationController
  protect_from_forgery except: %w(game privacy tos)

  # GET /about/game
  def game
  end

  # GET /about/privacy
  def privacy
  end

  # GET /about/tos
  def tos
  end
end
