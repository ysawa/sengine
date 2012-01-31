require 'spec_helper'

describe Game do
  describe '.save' do
    let :game do
      Fabricate.build(:game)
    end
    it 'works!' do
      game.save.should be_true
    end
  end
end
