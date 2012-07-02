# -*- coding: utf-8 -*-

class Sys::UsersController < Sys::ApplicationController
  respond_to :html
  before_filter :find_users
  before_filter :find_user, only: %w(destroy edit set_admin show unset_admin udpate)

  # GET /setting/edit
  def edit
    respond_with(@user)
  end

  def index
    @users = @users.page(params[:page])
  end

  def set_admin
    @user.admin = true
    if (current_user != @user) && @user.save
      respond_with(@user, location: sys_user_path(@user))
    else
      render :show
    end
  end

  # GET /setting
  def show
    respond_with(@user)
  end

  def unset_admin
    @user.admin = true
    if (current_user != @user) && @user.save
      respond_with(@user, location: sys_user_path(@user))
    else
      render :show
    end
  end

  # PUT /setting
  def update
    if @user.update_attributes(params[:user])
      respond_with(@user, location: sys_user_path(@user))
    else
      render :edit
    end
  end

private

  def find_user
    @user = @users.find(params[:id])
  end

  def find_users
    @users = User.all
  end
end
