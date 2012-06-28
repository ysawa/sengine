require 'spec_helper'

describe PieceDecorator do
  before :each do
    setup_controller_request
    @game = Fabricate(:game)
    @board = Board.hirate
    @board.game = @game
    @board.save
    @piece = Piece.new(Piece::FU)
    @decorator = PieceDecorator.new(@piece)
  end

  describe '.tagify' do
    it 'make .piece tag' do
      piece_tag = @decorator.tagify(true)
      piece_tag.should include "<div"
      piece_tag.should include "piece"
      piece_tag.should include "role_fu"
    end
  end
end
