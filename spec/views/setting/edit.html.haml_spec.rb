# -*- coding: utf-8 -*-

require 'spec_helper'

describe "setting/edit" do
  before :each do
    setup_controller_request
    user_sign_in
  end

  it "renders setting/edit" do
    render
  end
end
