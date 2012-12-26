# -*- coding: utf-8 -*-

class TagsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user_but_pass_crawler!
  before_filter :find_taggable
  before_filter :find_tag, only: [:destroy, :show]

  # POST /tags
  def create
    @tag = Tag.new(params[:tag])
    @tag.author = current_user
    if @tag.save
      respond_with(@tag, location: tags_path)
    else
      render text: 'NG', status: 422
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
    respond_with @tag
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
    @subtitle = @tag
    respond_with @tag
  end

private

  def find_tag
    @tag = Tag.find_by_code(params[:id])
  end

  def find_taggable
    @taggable = nil
  end
end
