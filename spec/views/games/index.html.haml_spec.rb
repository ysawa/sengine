# -*- coding: utf-8 -*-

require 'spec_helper'

describe "games/index" do
  before(:each) do
    user_sign_in
    @opponent = Fabricate(:user, name: 'opponent')
    @board = Board.hirate
    @game = Game.new
    @board.game = @game
    @board.save
    @sente_user = Fabricate(:user)
    @gote_user = Fabricate(:user)
    @game = Game.new
    @game.sente_user = @sente_user
    @game.gote_user = @gote_user
    @game.save
    assign(:games, Game.all.page)
  end

  it "renders a list of games" do
    render
    rendered.should match @game.sente_user.name
    rendered.should match @game.gote_user.name
  end
end
