# -*- coding: utf-8 -*-

require 'spec_helper'

describe "setting/show" do
  before :each do
    setup_controller_request
    user_sign_in
  end

  it "renders setting/show" do
    render
  end
end
