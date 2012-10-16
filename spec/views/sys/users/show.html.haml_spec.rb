# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/users/show" do
  before :each do
    @user = Fabricate(:user)
    user_sign_in(@user)
    assign(:user, @user)
  end

  it "renders sys/users/show" do
    render
  end
end
