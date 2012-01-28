require 'spec_helper'

describe Game do
  describe '.save' do
    let :game do
      Game.new
    end
    it 'works!' do
      game.save.should be_true
    end
  end
end
