# -*- coding: utf-8 -*-

require 'spec_helper'

describe "comments/index" do
  before(:each) do
    user_sign_in
    @comment = Fabricate(:comment, content: 'Comment Content')
    assign(:comments, Comment.all.page(1))
  end

  it "renders a list of comments" do
    render
    rendered.should match('Comment Content')
  end
end
