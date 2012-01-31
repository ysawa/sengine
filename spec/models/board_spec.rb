require 'spec_helper'

describe Board do
  describe '.save' do
    let :board do
      Fabricate.build(:board)
    end
    it 'works!' do
      board.save.should be_true
    end
  end
end
