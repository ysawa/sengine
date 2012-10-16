# -*- coding: utf-8 -*-

require 'spec_helper'

describe "sys/games/show" do
  before :each do
    user_sign_in
    @board = Board.hirate
    @board.game = @game
    @board.save
    @sente_user = Fabricate(:user)
    @gote_user = Fabricate(:user)
    @game = Game.new
    @game.sente_user = @sente_user
    @game.gote_user = @gote_user
    @game.save
    assign(:game, @game)
    @board = Board.hirate
    @board.game = @game
    @board.save
    assign(:board, @board)
  end

  it "renders sys/games/show" do
    render
  end
end
