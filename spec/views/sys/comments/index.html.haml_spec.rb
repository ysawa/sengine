# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/comments/index" do
  before :each do
    @comment = Fabricate(:comment)
    user_sign_in
    assign(:comments, Comment.all.page)
  end

  it "renders sys/comments/index" do
    render
    # rendered.should have_selector 'table.table'
  end
end
