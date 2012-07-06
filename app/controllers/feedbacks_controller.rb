# -*- coding: utf-8 -*-

class FeedbacksController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_user!
  before_filter :find_feedback, only: [:show]

  # POST /feedbacks
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.author = current_user
    if @feedback.save
      flash[:notice] = t('notices.thanks_for_feedbacking')
      respond_with(@feedback, location: feedbacks_path)
    else
      render text: "Invalid Attributes", status: :internal_server_error
    end
  end

  # GET /feedbacks
  def index
    @feedbacks = Feedback.parents.published.page(params[:page])
    @feedback = Feedback.new
    respond_with(@feedbacks)
  end

  # GET /feedbacks/1
  def show
    respond_with(@feedback)
  end

private
  def find_feedback
    @feedback = Feedback.find(params[:id])
  end
end
