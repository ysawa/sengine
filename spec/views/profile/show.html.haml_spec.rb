# -*- coding: utf-8 -*-

require 'spec_helper'

describe "profile/show" do
  before :each do
    user_sign_in
    @user = Fabricate(:user, name: 'opponent')
    assign(:user, @user)
  end

  it "renders successfully" do
    render
    rendered.should match @user.name
  end
end
