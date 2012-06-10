# -*- coding: utf-8 -*-

require 'spec_helper'

describe "games/index" do
  before(:each) do
    user_sign_in
    @opponent = Fabricate(:user, name: 'opponent')
    @game = Fabricate(:game, sente_user: @user, gote_user: @opponent)
    assign(:games, Game.all.page)
  end

  it "renders a list of games" do
    render
  end
end
