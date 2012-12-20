# -*- coding: utf-8 -*-

require 'spec_helper'

describe "comments/show" do
  before(:each) do
    user_sign_in
    @comment = assign(:comment, Fabricate(:comment, content: 'Comment Content'))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match('Comment Content')
  end
end
