# -*- coding: utf-8 -*-

require 'spec_helper'

describe "setting/edit" do
  before :each do
    user_sign_in
  end

  it "renders successfully" do
    render
    rendered.should match @user.name
  end
end
