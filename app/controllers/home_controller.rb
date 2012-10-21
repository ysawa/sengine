# -*- coding: utf-8 -*-

class HomeController < ApplicationController
  respond_to :html, :js
  protect_from_forgery except: %w(index)

  before_filter :authenticate_user!, only: [:notices]

  # GET /
  def index
    if params[:redirect]
      redirect_to params[:redirect]
      return
    end
    if params[:fb_source]
      render layout: 'facebook', action: :top
      return
    end
    if user_signed_in?
      make_subtitle(:mypage)
      render action: :mypage
    else
      @subtitle = nil
      @top_page = true
      render action: :top
    end
  end

  # GET /notices
  def notices
  end
end
