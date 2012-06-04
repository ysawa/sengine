require 'spec_helper'

describe "games/show" do
  before(:each) do
    user_sign_in
    @game = assign(:game, stub_model(Game))
    @game.boards << Board.hirate
    @board = assign(:board, @game.boards.first)
  end

  it "renders a board with 81 cells" do
    render
    # board should have 81 cells
    assert_select '.board' do
      assert_select '.cell', 81
    end
  end
end
