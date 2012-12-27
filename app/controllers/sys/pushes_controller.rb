# -*- coding: utf-8 -*-

class Sys::PushesController < ApplicationController

  before_filter :find_push, only: [:destroy, :edit, :show, :update]

  def create
  end

  def destroy
    @push.destroy
  end

  def edit
  end

  def index
    @pushes = Push.all.page(params[:page])
  end

  def new
  end

  def show
  end

  def update
  end

private

  def find_push
    @push = Push.find(params[:id])
  end
end
