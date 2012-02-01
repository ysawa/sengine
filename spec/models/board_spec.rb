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
      fu = board.piece_on_point([1, 3])
      fu.should be_present
      fu.role.should == 'fu'
      fu.sente.should be_false
      kaku = board.piece_on_point([8, 8])
      kaku.should be_present
      kaku.role.should == 'kaku'
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

  describe 'Board.hirate' do
    let :board do
      Board.hirate
    end

    it 'works!' do
      board.sente.should be_false
      board.number.should == 0
      fu = board.piece_on_point([1, 3])
      fu.should be_present
      fu.role.should == 'fu'
      fu.sente.should be_false
      kaku = board.piece_on_point([8, 8])
      kaku.should be_present
      kaku.role.should == 'kaku'
      kaku.sente.should be_true
    end
  end
end
