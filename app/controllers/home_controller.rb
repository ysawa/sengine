# -*- coding: utf-8 -*-

class HomeController < ApplicationController
  respond_to :html

  def index
    if user_signed_in?
      make_subtitle(:mypage)
      render action: :mypage
    else
      @subtitle = nil
      render action: :top
    end
  end
end
