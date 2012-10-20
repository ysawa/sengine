# -*- coding: utf-8 -*-

class CommentsController < ApplicationController
  respond_to :html
  before_filter :find_comment, only: %w(destroy edit show update)

  # POST /comments
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = "Comment successfully created"
      respond_with(@comment)
    else
      render :new
    end
  end

  # DELETE /comments/1
  def destroy
    flash[:notice] = "Comment successfully destroyed." if @comment.destroy
    respond_with(@comment, location: comments_path)
  end

  # GET /comments/1/edit
  def edit
    respond_with(@comment) do |format|
      format.html { render action: :edit }
    end
  end

  # GET /comments
  def index
    respond_with(@comments = Comment.all)
  end

  # GET /comments/new
  def new
    respond_with(@comment = Comment.new)
  end

  # GET /comments/1
  def show
    respond_with(@comment)
  end

  # PUT /comments/1
  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Comment successfully updated."
      respond_with(@comment)
    else
      render :edit
    end
  end

private

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
