# -*- coding: utf-8 -*-

class Sys::FeedbacksController < ApplicationController
  respond_to :html, :js
  before_filter :find_feedbacks

  # GET /sys/feedbacks/edit
  def edit
    respond_with(@feedback)
  end

  # GET /sys/feedbacks
  def index
    @feedbacks = @feedbacks.desc(:created_at).page(params[:page])
  end

  # GET /sys/feedbacks
  def show
    if params[:number].present?
      @board = @feedback.boards.where(number: params[:number].to_i).first
    else
      @board = @feedback.boards.last
    end
    respond_with(@feedback)
  end

  # PUT /sys/feedbacks
  def update
    if @feedback.update_attributes(params[:feedback])
      respond_with(@feedback, location: sys_feedback_path(@feedback))
    else
      render :edit
    end
  end

private

  def find_feedback
    @feedback = @feedbacks.find(params[:id])
  end

  def find_feedbacks
    @feedbacks = Feedback.all
  end
end
