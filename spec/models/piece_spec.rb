require 'spec_helper'

describe Piece do
  let :piece do
    Fabricate.build(:piece)
  end

  describe '.save' do
    it 'works!' do
      piece.save.should be_true
    end
  end

  describe '.point' do
    it 'works!' do
      piece.point = nil
      piece.point.should be_nil
      piece.point = [1, 2]
      piece.point.should == [1, 2]
      piece.read_attribute(:point).should == {'x' => 1, 'y' => 2}
    end
  end
end
