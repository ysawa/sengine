# -*- coding: utf-8 -*-

require 'spec_helper'
require 'shogi_bot'

describe ShogiBot::Board do
  before :each do
    @bot = MinnaBot.new
  end

  describe '.initialize' do
    it 'generate board with board data and number' do
      board = ShogiBot::Board.new([], 1)
      board.number.should == 1
    end
  end

  describe '.load_kikis' do
    before :each do
      @board = @bot.encode_board(Board.hirate)
    end
    it 'successfully generates sente and gote kikis' do
      @board.load_kikis
      @board.sente_kikis.should be_a ShogiBot::Kikis
      @board.sente_kikis.get_move_kikis(61).should == [10] # FU
      @board.sente_kikis.get_jump_kikis(61).should == [] # NONE
      @board.sente_kikis.get_jump_kikis(71).should == [10] # KY
      @board.sente_kikis.get_jump_kikis(81).should == [1, 10] # HI, KY
      @board.gote_kikis.should be_a ShogiBot::Kikis
      @board.gote_kikis.get_move_kikis(41).should == [-10] # FU
      @board.gote_kikis.get_jump_kikis(41).should == [] # NONE
      @board.gote_kikis.get_jump_kikis(31).should == [-10, -9] # KY, KA
      @board.gote_kikis.get_jump_kikis(21).should == [-10] # KY
      @board.gote_kikis.get_jump_kikis(11).should == [11] # KA
    end
  end
  describe '.load_ous' do
    before :each do
      @board = @bot.encode_board(Board.hirate)
    end
    it 'successfully generates sente and gote ous' do
      @board.load_kikis
      @board.load_ous
      @board.sente_ou.should == 95
      @board.gote_ou.should == 15
    end
  end
  describe '.load_pins' do
    before :each do
      @board = @bot.encode_board(Board.hirate)
    end
    it 'successfully generates sente and gote pins' do
      @board.load_kikis
      @board.load_ous
      @board.load_pins
    end
  end
end
