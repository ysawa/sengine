# -*- coding: utf-8 -*-

class TagsController < ApplicationController
  respond_to :html

  def index
    @tags = Tag.desc(:created_at).page(params[:page])
    respond_with @tags
  end

  def search
    @q = params[:q]
    @tags = Tag.search(@q).desc(:created_at).page(params[:page])
    respond_with @tags do |format|
      format.html { render action: 'index' }
    end
  end

  def show
    @tag = Tag.find_by_code(params[:id])
    respond_with @tag
  end
end
