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

  describe '.standardize' do
    it 'works!' do
      board.standardize
      board.black.should be_false
      board.number.should == 0
      fu = board.piece_where([1, 3])
      fu.should be_present
      fu.role.should == 'fu'
      fu.black.should be_false
    end
  end
end
