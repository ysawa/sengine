# -*- coding: utf-8 -*-

require 'spec_helper'
require 'shogi_bot'

describe ShogiBot::Board do
  before :each do
  end

  describe '.initialize' do
    it 'generate board with board data and number' do
      board = ShogiBot::Board.new([], 1)
      board.number.should == 1
    end
  end
end
