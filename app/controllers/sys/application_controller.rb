# -*- coding: utf-8 -*-

class Sys::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_should_be_admin
protected
  def user_should_be_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
