# -*- coding: utf-8 -*-

class TagsController < ApplicationController
  respond_to :html

  def index
    @tags = Tag.desc(:created_at).page(params[:page])
  end

  def show
    @tag = Tag.find_by_code(params[:id])
  end
end
