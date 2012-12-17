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
    it 'creates hirate boards and initializes the turn and other information.' do
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
        from_point: [7, 7],
        to_point: [7, 6],
        role: Piece::FU,
        number: 1,
        sente: true,
        put: false
      }
      Fabricate(:movement, attributes)
    end

    let :put_board do
      b = Board.hirate
      b.sente_hand = [nil, 1, 0, 0, 0, 0, 0, 0, 0]
      b.p_75 = nil
      b
    end

    let :put_movement do
      attributes = {
        from_point: nil,
        to_point: [5, 5],
        role: Piece::FU,
        number: 1,
        sente: true,
        put: true
      }
      Fabricate(:movement, attributes)
    end

    it 'works if movement is normal move!' do
      piece_from_point = board.get_piece(movement.from_point)
      piece_to_point = board.get_piece(movement.to_point)
      piece_from_point.sente?.should be_true
      piece_from_point.role.should == Piece::FU
      piece_to_point.should be_blank
      board.number = 1
      board.apply_movement(movement)

      board.movement.should == movement
      piece_from_point = board.get_piece(movement.from_point)
      piece_to_point = board.get_piece(movement.to_point)
      piece_from_point.should be_nil
      piece_to_point.role.should == Piece::FU
    end

    it 'works if movement is normal put!' do
      piece_to_point = put_board.get_piece(put_movement.to_point)
      piece_to_point.should be_blank
      put_board.number = 1
      put_board.apply_movement(put_movement)

      put_board.movement.should == put_movement
      piece_to_point = put_board.get_piece(put_movement.to_point)
      piece_to_point.role.should == Piece::FU
    end

    it 'fails if movement have invalid number (number should be same)' do
      piece_from_point = board.get_piece(movement.from_point)
      piece_to_point = board.get_piece(movement.to_point)
      piece_from_point.role.should == Piece::FU
      piece_to_point.should be_blank
      board.number = 2
      lambda { board.apply_movement(movement) }.should raise_error
    end

    it 'fails if movement have invalid moving' do
      movement.attributes = {
        from_point: [5, 5],
        role: Piece::FU,
        to_point: [5, 5]
      }
      piece_from_point = board.get_piece(movement.from_point)
      piece_from_point.should be_blank
      piece_to_point = board.get_piece(movement.to_point)
      piece_to_point.should be_blank
      board.number = 1
      lambda { board.apply_movement(movement) }.should raise_error
    end

    it 'fails if movement have invalid putting' do
      movement.attributes = {
        from_point: nil,
        put: true,
        role: Piece::FU,
        to_point: [5, 5]
      }
      piece_to_point = board.get_piece(movement.to_point)
      piece_to_point.should be_blank
      board.number = 1
      lambda { board.apply_movement(movement) }.should raise_error
    end

    it 'fails if movement have invalid taking (cannot be taken)' do
      movement.attributes = {
        from_point: [1, 9],
        role: Piece::KY,
        to_point: [1, 7]
      }
      piece_from_point = board.get_piece(movement.from_point)
      piece_to_point = board.get_piece(movement.to_point)
      piece_from_point.role.should == Piece::KY
      piece_to_point.role.should == Piece::FU
      board.number = 1
      lambda { board.apply_movement(movement) }.should raise_error
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

  describe '.to_json' do
    it 'generates JSON successfully' do
      board.to_json
    end
  end
end
