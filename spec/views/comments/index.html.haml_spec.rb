# -*- coding: utf-8 -*-

require 'spec_helper'

describe "comments/index" do
  before(:each) do
    user_sign_in
    @author = Fabricate(:user, name: 'Author Name')
    @comment = assign(:comment, Fabricate(:comment, content: 'Comment Content', author: @author))
    assign(:comments, Comment.all.page(1))
  end

  it "renders a list of comments" do
    render
    rendered.should have_content('Comment Content')
    rendered.should have_selector("img[title='Author Name']")
  end
end
