# -*- coding: utf-8 -*-

require 'spec_helper'

describe "feedbacks/index" do
  before(:each) do
    user_sign_in
    @feedback = Fabricate(:feedback)
    assign(:feedbacks, Feedback.all.page)
  end

  it "renders a list of feedbacks" do
    pending 'Test is not valid'
    render
  end
end
