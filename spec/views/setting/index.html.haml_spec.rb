# -*- coding: utf-8 -*-

require 'spec_helper'

describe "setting/index" do
  before :each do
    user_sign_in
  end

  it "renders setting/index" do
    render
  end
end
