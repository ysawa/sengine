# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/games/show" do
  before :each do
    @game = Fabricate(:game)
    user_sign_in
    assign(:game, @game)
  end

  it "renders sys/games/show" do
    render
  end
end
