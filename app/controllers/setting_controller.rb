# -*- coding: utf-8 -*-

class SettingController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  def edit
    respond_with(current_user)
  end

  def show
    respond_with(current_user)
  end

  def update
    if current_user.update_attributes(params[:user])
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
