# -*- coding: utf-8 -*-

require 'spec_helper'

describe "feedbacks/show" do
  before(:each) do
    user_sign_in
    @feedback = assign(:feedback, stub_model(Feedback,
      :content => "内容"
    ))
  end

  it "renders attributes in <p>" do
    pending 'Test is not valid'
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/内容/)
  end
end
