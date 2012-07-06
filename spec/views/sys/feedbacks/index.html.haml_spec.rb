# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/feedbacks/index" do
  before :each do
    setup_controller_request
    @feedback = Fabricate(:feedback)
    user_sign_in
    assign(:feedbacks, Feedback.all.page)
  end

  it "renders sys/feedbacks/index" do
    render
  end
end
