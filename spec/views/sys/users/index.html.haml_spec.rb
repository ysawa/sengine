# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/users/index" do
  before :each do
    @user = Fabricate(:user)
    user_sign_in(@user)
    assign(:users, User.all.page)
  end

  it "renders sys/users/index" do
    render
  end

  it "renders with pagination" do
    pending "tests doesn't work correctly."
    render
    rendered.should have_selector 'nav.pagination'
  end
end
