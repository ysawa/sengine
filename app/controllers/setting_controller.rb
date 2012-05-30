# -*- coding: utf-8 -*-

class SettingController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def index
  end
end
