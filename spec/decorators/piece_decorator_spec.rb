require 'spec_helper'

describe PieceDecorator do
  before :each do
    setup_controller_request
    @game = Fabricate(:game)
    @board = Board.hirate
    @board.game = @game
    @board.save
    @piece = Fabricate(:piece, board: @board)
    @decorator = PieceDecorator.new(@piece)
  end

  describe '.tagify' do
    it 'make .piece tag' do
      piece_tag = @decorator.tagify(true)
      piece_tag.should include "<div"
      piece_tag.should include "piece"
      piece_tag.should include "id=\"#{@piece.id}\""
    end
  end
end
