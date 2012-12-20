# -*- coding: utf-8 -*-

require 'spec_helper'

describe "comments/show" do
  before(:each) do
    user_sign_in
    @author = Fabricate(:user, name: 'Author Name')
    @comment = assign(:comment, Fabricate(:comment, content: 'Comment Content', author: @author))
  end

  it "renders the comment detail" do
    render
    rendered.should have_content('Comment Content')
    rendered.should have_selector("img[title='Author Name']")
  end
end
