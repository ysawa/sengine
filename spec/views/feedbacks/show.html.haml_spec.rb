# -*- coding: utf-8 -*-

require 'spec_helper'

describe "feedbacks/show" do
  before(:each) do
    user_sign_in
    @author = Fabricate(:user)
    @feedback = Fabricate(:feedback, author: @author)
    assign(:feedback, @feedback)
  end

  it "renders successfully" do
    render
    rendered.should match @feedback.content
  end
end
