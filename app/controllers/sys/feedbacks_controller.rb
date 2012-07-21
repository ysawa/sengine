# -*- coding: utf-8 -*-

class Sys::FeedbacksController < Sys::ApplicationController
  respond_to :html, :js
  before_filter :find_feedbacks
  before_filter :find_feedback, only: [:destroy, :edit, :show, :update]

  # DELETE /sys/feedbacks/1
  def destroy
    @feedback.destroy
    respond_with(@feedback, location: [:sys, @feedback])
  end

  # GET /sys/feedbacks/1/edit
  def edit
    respond_with(@feedback)
  end

  # GET /sys/feedbacks
  def index
    @feedbacks = @feedbacks.desc(:created_at).page(params[:page])
  end

  # GET /sys/feedbacks/1
  def show
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
