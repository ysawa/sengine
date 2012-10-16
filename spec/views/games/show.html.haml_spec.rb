# -*- coding: utf-8 -*-

require 'spec_helper'

describe "games/show" do
  before(:each) do
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

  it "renders a board with 81 cells" do
    render
    # board should have 81 cells
    assert_select '.board' do
      assert_select '.cell', 81
    end
  end
end
