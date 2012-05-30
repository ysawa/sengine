# -*- coding: utf-8 -*-

require 'spec_helper'

describe "help/usage" do
  before :each do
    user_sign_in
  end

  it "renders help/usage" do
    render
  end
end
