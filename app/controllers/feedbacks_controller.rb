# -*- coding: utf-8 -*-

class FeedbacksController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user_but_introduce_crawler!, only: [:create, :dislike, :like]
  before_filter :find_feedback, only: [:dislike, :like, :show]

  # POST /feedbacks
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.author = current_user
    if @feedback.publish!
      flash[:notice] = t('notices.thanks_for_feedbacking')
      respond_with(@feedback, location: feedbacks_path)
    else
      render text: "Invalid Attributes", status: :internal_server_error
    end
  end

  # PUT /feedbacks/1/dislike
  def dislike
    @feedback.dislike!(current_user)
    # flash[:notice] = t('notices.thanks_for_disliking')
    respond_with(@feedback, location: feedbacks_path)
  end

  # PUT /feedbacks/1/like
  def like
    @feedback.like!(current_user)
    # flash[:notice] = t('notices.thanks_for_liking')
    respond_with(@feedback, location: feedbacks_path)
  end

  # GET /feedbacks
  def index
    @feedbacks = Feedback.parents.published.unsuccess.desc(:created_at)
    @feedbacks = @feedbacks.page(params[:page]).per(10)
    @feedback = Feedback.new
    respond_with(@feedbacks)
  end

  # GET /feedbacks/1
  def show
    respond_with(@feedback)
  end

  # GET /games/success
  def success
    @feedbacks = Feedback.parents.published.success.desc(:created_at)
    @feedbacks = @feedbacks.page(params[:page]).per(10)
    @feedback = Feedback.new
    respond_with(@feedbacks) do |format|
      format.html { render :index }
    end
  end

private
  def find_feedback
    @feedback = Feedback.find(params[:id])
  end
end
