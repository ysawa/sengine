# -*- coding: utf-8 -*-

require 'spec_helper'

describe Board do
  let :board do
    Fabricate.build(:board)
  end

  describe '.save' do
    it 'works!' do
      board.save.should be_true
    end
  end

  describe '.hirate' do
    it 'works!' do
      board.hirate
      board.sente.should be_false
      board.number.should == 0
      fu = board.get_piece([1, 3])
      fu.should be_present
      fu.role.should == Piece::FU
      fu.sente.should be_false
      kaku = board.get_piece([8, 8])
      kaku.should be_present
      kaku.role.should == Piece::KA
      kaku.sente.should be_true
    end
  end

  describe '.destroy' do
    let :board do
      Fabricate(:board, movement: Fabricate(:movement))
    end

    it 'works!' do
      board
      Board.count.should == 1
      board.destroy.should be_true
      Board.count.should == 0
    end

    it 'destroy_movement also works!' do
      board
      Movement.count.should == 1
      board.destroy
      Movement.count.should == 0
    end
  end

  describe '.apply_movement' do
    let :board do
      Board.hirate
    end

    let :movement do
      attributes = {
        from_point: [7, 3],
        to_point: [7, 4],
        role: Piece::FU
      }
      Fabricate(:movement, attributes)
    end

    it 'works!' do
      piece_from_point = board.get_piece(movement.from_point)
      piece_to_point = board.get_piece(movement.to_point)
      piece_from_point.role.should == Piece::FU
      piece_to_point.should be_blank
      board.apply_movement(movement)

      board.movement.should == movement
      piece_from_point = board.get_piece(movement.from_point)
      piece_to_point = board.get_piece(movement.to_point)
      piece_from_point.should be_nil
      piece_to_point.role.should == Piece::FU
    end

    it 'can take opponent piece' do
    end
  end

  describe 'Board.hirate' do
    let :board do
      Board.hirate
    end

    it 'works!' do
      board.sente.should be_false
      board.number.should == 0
      fu = board.get_piece([1, 3])
      fu.should be_present
      fu.role.should == Piece::FU
      fu.sente.should be_false
      kaku = board.get_piece([8, 8])
      kaku.should be_present
      kaku.role.should == Piece::KA
      kaku.sente.should be_true
    end
  end
end
