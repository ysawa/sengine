# -*- coding: utf-8 -*-

require 'spec_helper'

describe "about/game" do
  before :each do
  end

  it "renders the first explanation for visitors" do
    render
    rendered.should include "<h3>\nFacebookの友達と将棋を指そう!\n</h3>"
  end
end
