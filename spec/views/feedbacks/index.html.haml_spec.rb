# -*- coding: utf-8 -*-

require 'spec_helper'

describe "feedbacks/index" do
  before(:each) do
    @feedback = Fabricate(:feedback)
    assign(:feedbacks, Feedback.all.page)
  end

  it "renders a list of feedbacks" do
    render
  end
end
