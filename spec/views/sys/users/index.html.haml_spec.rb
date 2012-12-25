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
    rendered.should have_selector 'table.table'
  end
end
