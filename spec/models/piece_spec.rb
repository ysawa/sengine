# -*- coding: utf-8 -*-

require 'spec_helper'

describe Piece do
  let :board do
    Fabricate(:board)
  end

  let :piece do
    Piece.new(1) # SENTE FU
  end

  describe '.sente? and .gote?' do
    it 'both work!' do
      piece.sente = true
      piece.sente?.should be_true
      piece.gote?.should be_false
      piece.sente = false
      piece.sente?.should be_false
      piece.gote?.should be_true
    end
  end

  describe '.reverse and .normalize' do
    it 'both work!' do
      piece.value = Piece::HI
      piece.reverse
      piece.role.should == Piece::RY
      piece.normalize
      piece.role.should == Piece::HI
    end
  end
end
