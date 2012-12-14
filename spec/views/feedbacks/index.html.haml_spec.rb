# -*- coding: utf-8 -*-

require 'spec_helper'

describe "feedbacks/index" do
  before(:each) do
    user_sign_in
    @author = Fabricate(:user)
    @feedback = Fabricate(:feedback, author: @author)
    assign(:feedbacks, Feedback.all.page)
  end

  it "renders a list of feedbacks" do
    render
    rendered.should match @feedback.content
  end
end
