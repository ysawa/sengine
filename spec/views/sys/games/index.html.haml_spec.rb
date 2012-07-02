# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/games/index" do
  before :each do
    @game = Fabricate(:game)
    user_sign_in
    assign(:games, Game.all.page)
  end

  it "renders sys/games/index" do
    render
  end
end
