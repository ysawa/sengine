# -*- coding: utf-8 -*-

class HomeController < ApplicationController

  def index
    if user_signed_in?
      render action: :mypage
    else
      render action: :top
    end
  end
end
