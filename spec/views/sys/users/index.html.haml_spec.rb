# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/users/index" do
  before :each do
    setup_controller_request
    @user = Fabricate(:user)
    user_sign_in(@user)
    assign(:users, User.all.page)
  end

  it "renders sys/users/index" do
    render
  end
end
