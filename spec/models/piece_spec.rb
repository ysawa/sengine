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

  describe '.moves' do
    it 'generates a correct array of moves' do
      piece.moves.should == [-1]
      piece.sente = false
      piece.moves.should == [1]
      piece.role = Piece::HI
      piece.moves.should == []
    end
  end

  describe '.jumps' do
    it 'generates a correct array of jumps' do
      piece.jumps.should == []
      piece.role = Piece::HI
      piece.jumps.should == [-10, -1, 1, 10]
      piece.sente = false
      piece.jumps.should == [-10, -1, 1, 10]
    end
  end

  describe '.role' do
    it 'shows piece role with positive integer' do
      piece = Piece.new(Piece::KY)
      piece.role.should == Piece::KY
      piece = Piece.new(- Piece::KY)
      piece.role.should == Piece::KY
    end
  end

  describe '.value' do
    it 'shows piece role and sente or gote with positive or negative integer' do
      piece = Piece.new(Piece::KY)
      piece.sente = true
      piece.value.should == Piece::KY
      piece = Piece.new(Piece::KY)
      piece.sente = false
      piece.value.should == - Piece::KY
    end
  end

  describe '.stringify_role' do
    it 'generates corresponding role string' do
      piece = Piece.new(Piece::FU)
      piece.stringify_role == '歩'
      piece = Piece.new(Piece::KY)
      piece.stringify_role == '香'
      piece = Piece.new(Piece::RY)
      piece.stringify_role == '竜'
    end
  end
end
