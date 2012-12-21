# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/feedbacks/show" do
  before :each do
    @feedback = Fabricate(:feedback)
    user_sign_in
    assign(:feedback, @feedback)
  end

  it "renders sys/feedbacks/show" do
    render
    rendered.should have_content @feedback.content
  end
end
