# -*- coding: utf-8 -*-

class CommentsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user_but_introduce_crawler!
  before_filter :find_comment, only: %w(destroy show)
  before_filter :find_commentable

  # GET /games/1/comments/check_update
  def check_update
    if @game
      @comments = @game.comments
      if params[:after]
        after = Time.parse(params[:after])
        @comments = @comments.where(:created_at.gt => after)
      else
        @comments = @game.comments
      end
      if params[:except_ids]
        except_ids = params[:except_ids].collect { |id| Moped::BSON::ObjectId(id) }
        @comments = @comments.where(:_id.nin => except_ids)
      end
      if @comments.present?
        @comments = @comments.desc(:created_at).to_a
        render
      else
        result = 'NO UPDATE'
        render text: result, content_type: Mime::TEXT
      end
    else
      flash[:notice] = t('notices.someone_deleted_this_game')
      render js: "window.location = '/'"
    end
  end

  # POST /comments
  def create
    @comment = Comment.new(params[:comment])
    @comment.author = current_user
    @comment.commentable = @commentable if @commentable
    if @comment.save
      respond_with(@comment, location: game_comment_path(@game, @comment))
    else
      render :new
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
    respond_with(@comment, location: game_comments_path(@game))
  end

  # GET /comments
  def index
    if @commentable
      @comments = @commentable.comments.desc(:created_at).page(params[:page]).per(5)
    else
      @comments = Comment.all.desc(:created_at).page(params[:page]).per(5)
    end
    respond_with(@comments)
  end

  # GET /comments/new
  def new
    @comment = Comment.new(commentable: @commentable)
    respond_with(@comment)
  end

  # GET /comments/1
  def show
    respond_with(@comment)
  end

private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def find_commentable
    if params[:game_id]
      @commentable = @game = Game.find(params[:game_id])
    end
  end
end
