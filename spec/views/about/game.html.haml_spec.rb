# -*- coding: utf-8 -*-

require 'spec_helper'

describe "about/game" do
  before :each do
  end

  it "renders about/us that is the first explanation for visitors" do
    render
    rendered.should include "<h3>\nShall we play Shogi with your facebook friends?\n</h3>"
  end

  context 'when locale is ja' do
    before :each do
    end

    it "renders about/game" do
      render partial: 'about/game.ja'
      rendered.should include "<h3>\nFacebookの友達と将棋を指そう!\n</h3>"
    end
  end
end
