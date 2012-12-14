# -*- coding: utf-8 -*-

class Sys::TagsController < Sys::ApplicationController
  respond_to :html

  before_filter :find_tags, only: %w(index)
  before_filter :find_tag, only: %w(edit show update)

  # GET /sys/tags
  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      respond_with(@tag, location: sys_tag_path(@tag))
    else
      render :edit
    end
  end

  # GET /sys/tags/1/edit
  def edit
    respond_with(@tag)
  end

  # GET /sys/tags
  def index
    @tags = @tags.page(params[:page])
    respond_with(@tags)
  end

  # GET /sys/tags/new
  def new
    @tag = Tag.new
    render action: :edit
  end

  # GET /sys/tags/1
  def show
    respond_with(@tag)
  end

  # PUT /sys/tags/1
  def update
    if @tag.update_attributes(params[:tag])
      respond_with(@tag, location: sys_tag_path(@tag))
    else
      render :edit
    end
  end

private

  def find_tag
    @tag = Tag.find_by_code(params[:id])
  end

  def find_tags
    @tags = Tag.all
  end
end
