# -*- coding: utf-8 -*-

require 'spec_helper'

describe "feedbacks/show" do
  before(:each) do
    user_sign_in
    @feedback = assign(:feedback, stub_model(Feedback,
      :content => "内容"
    ))
  end

  it "renders successfully" do
    render
  end
end
