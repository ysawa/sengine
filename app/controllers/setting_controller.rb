# -*- coding: utf-8 -*-

class SettingController < ApplicationController
  respond_to :html
  before_filter :authenticate_user_but_introduce_crawler!
  before_filter :set_objective

  # GET /setting/edit
  def edit
    respond_with(current_user)
  end

  # PUT /setting
  def update
    if current_user.update_attributes(params[:user])
      set_locale
      make_setting_notice
      if @objective
        respond_with(current_user, location: edit_setting_objective_path(@objective))
      else
        respond_with(current_user, location: root_path)
      end
    else
      render :edit
    end
  end
private
  def make_setting_notice
    make_notice(t('user.setting'))
  end

  def set_objective
    @objective = params[:objective]
  end
end
