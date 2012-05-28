require 'spec_helper'

describe "games/show" do
  before(:each) do
    @game = assign(:game, stub_model(Game))
    @game.boards << Board.hirate
  end

  it "renders a board with 81 cells" do
    render
    # board should have 81 cells
    assert_select '.board' do
      assert_select '.cell', 81
    end
  end
end
