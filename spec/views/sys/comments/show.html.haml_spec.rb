# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/comments/show" do
  before :each do
    @comment = Fabricate(:comment)
    user_sign_in
    assign(:comment, @comment)
  end

  it "renders sys/comments/show" do
    render
    # rendered.should have_content @comment.content
  end
end
