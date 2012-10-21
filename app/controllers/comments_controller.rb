# -*- coding: utf-8 -*-

class CommentsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user!
  before_filter :find_comment, only: %w(destroy edit show update)
  before_filter :find_game

  # POST /comments
  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user
    @comment.game = @game if @game
    if @comment.save
      respond_with(@comment)
    else
      render :new
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    respond_with(@comment, location: game_comments_path(@game))
  end

  # GET /comments/1/edit
  def edit
    respond_with(@comment) do |format|
      format.html { render action: :edit }
    end
  end

  # GET /comments
  def index
    if @game
      @comments = @game.comments.desc(:created_at).page(params[:page]).per(5)
    else
      @comments = Comment.all.desc(:created_at).page(params[:page]).per(5)
    end
    respond_with(@comments)
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
      respond_with(@comment)
    else
      render :edit
    end
  end

private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def find_game
    if params[:game_id]
      @game = Game.find(params[:game_id])
    end
  end
end
