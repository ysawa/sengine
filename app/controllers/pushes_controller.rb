# -*- coding: utf-8 -*-

class PushesController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :find_push, only: [:hide]

  # PUT /pushes/1/hide
  def hide
    @push.hide_user!(current_user)
    respond_with(@push) do |format|
      format.html { redirect_to pushes_path }
      format.json { render nothing: true }
    end
  end

  # GET /pushes
  def index
    @pushes = Push.visible(current_user).shown(current_user).page(params[:page])
    respond_with(@pushes)
  end

private

  def find_push
    @push = Push.find(params[:id])
  end
end
