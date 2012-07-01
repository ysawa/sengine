# -*- coding: utf-8 -*-

class HomeController < ApplicationController
  respond_to :html
  protect_from_forgery except: %w(index)

  # GET /
  def index
    if user_signed_in?
      make_subtitle(:mypage)
      render action: :mypage
    else
      @subtitle = nil
      @top_page = true
      render action: :top
    end
  end
end
