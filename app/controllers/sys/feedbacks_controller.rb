# -*- coding: utf-8 -*-

class Sys::FeedbacksController < Sys::ApplicationController
  respond_to :html, :js
  before_filter :find_feedbacks
  before_filter :find_feedback, only: [:destroy, :edit, :show, :publish, :unpublish, :update]

  # POST /feedbacks
  def create
    @new_feedback = Feedback.new(params[:feedback])
    @new_feedback.author = current_user
    if @new_feedback.save
      make_feedback_notice
      respond_with(@new_feedback, location: [:sys, @new_feedback.parent || @new_feedback])
    else
      render text: "Invalid Attributes", status: :internal_server_error
    end
  end

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
    @feedbacks = @feedbacks.parents.desc(:created_at).page(params[:page])
  end

  # GET /sys/feedbacks/1
  def show
    @new_feedback = Feedback.new
    @new_feedback.parent_id = @feedback.id
    respond_with(@feedback)
  end

  # PUT /sys/feedbacks/1/publish
  def publish
    if @feedback.publish!
      make_feedback_notice
      respond_with(@feedback, location: sys_feedbacks_path)
    else
      redirect_to sys_feedbacks_path
    end
  end

  # PUT /sys/feedbacks/1/unpublish
  def unpublish
    if @feedback.unpublish!
      make_feedback_notice
      respond_with(@feedback, location: sys_feedbacks_path)
    else
      redirect_to sys_feedbacks_path
    end
  end

  # PUT /sys/feedbacks/1
  def update
    if @feedback.update_attributes(params[:feedback])
      make_feedback_notice
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

  def make_feedback_notice
    make_notice(Feedback.model_name.human)
  end
end
