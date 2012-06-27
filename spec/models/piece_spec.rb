# -*- coding: utf-8 -*-

require 'spec_helper'

describe Piece do
  let :board do
    Fabricate(:board)
  end

  let :piece do
    Piece.new(1) # SENTE FU
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
      piece.role = 'hisha'
      piece.reverse
      piece.role.should == 'ryu'
      piece.normalize
      piece.role.should == 'hisha'
    end
  end
end
