# -*- coding: utf-8 -*-

require 'spec_helper'

describe "profile/show" do
  before :each do
    setup_controller_request
    user_sign_in
    assign(:user, Fabricate(:user, name: 'opponent'))
  end

  it "renders profile/show" do
    render
  end
end
