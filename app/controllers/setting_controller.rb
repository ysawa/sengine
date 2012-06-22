# -*- coding: utf-8 -*-

class SettingController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  # GET /setting/edit
  def edit
    respond_with(current_user)
  end

  # GET /setting
  def show
    respond_with(current_user)
  end

  # PUT /setting
  def update
    if current_user.update_attributes(params[:user])
      set_locale
      make_setting_notice
      respond_with(current_user, location: setting_path)
    else
      render :edit
    end
  end
private
  def make_setting_notice
    make_notice(t('user.setting'))
  end
end