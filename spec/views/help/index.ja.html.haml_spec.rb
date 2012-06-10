# -*- coding: utf-8 -*-

require 'spec_helper'

describe "help/index.ja" do
  before :each do
    user_sign_in
  end

  it "renders help/index" do
    render
  end
end
