# -*- coding: utf-8 -*-

class Sys::UsersController < Sys::ApplicationController
  respond_to :html
  before_filter :find_users
  before_filter :find_user, only: %w(destroy edit set_admin show unset_admin update)

  # GET /sys/users/edit
  def edit
    respond_with(@user)
  end

  # GET /sys/users
  def index
    @users = @users.desc(:created_at).page(params[:page])
  end

  # PUT /sys/users/1/set_admin
  def set_admin
    @user.admin = true
    if @user.save && (current_user != @user)
      respond_with(@user, location: sys_user_path(@user))
    else
      render :show
    end
  end

  # GET /sys/users/1
  def show
    respond_with(@user)
  end

  # PUT /sys/users/1/unset_admin
  def unset_admin
    @user.admin = false
    if @user.save && (current_user != @user)
      respond_with(@user, location: sys_user_path(@user))
    else
      render :show
    end
  end

  # PUT /sys/users
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
