# -*- coding: utf-8 -*-

class TagsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user_but_pass_crawler!

  # POST /tags
  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      respond_with(@tag, location: tags_path)
    else
      render action: :index
    end
  end

  # GET /tags
  def index
    @tags = Tag.desc(:created_at).page(params[:page])
    respond_with @tags
  end

  # GET /tags/search
  # GET /tags/search/:q
  def search
    @q = params[:q]
    @tags = Tag.search(@q).desc(:created_at).page(params[:page])
    if @q.present?
      @subtitle = [@q, @subtitle]
    end
    respond_with @tags do |format|
      format.html { render action: 'index' }
    end
  end

  def show
    @tag = Tag.find_by_code(params[:id])
    @subtitle = @tag
    respond_with @tag
  end
end
