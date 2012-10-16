# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/users/edit" do
  before :each do
    @user = Fabricate(:user)
    user_sign_in(@user)
    assign(:user, @user)
  end

  it "renders sys/users/edit" do
    render
  end
end
