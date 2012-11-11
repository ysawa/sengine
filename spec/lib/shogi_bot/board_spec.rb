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
    it 'successfully generates sente and gote pins' do
      @board = @bot.encode_board(Board.hirate)
      @board.load_kikis
      @board.load_ous
      @board.load_pins
      @board.sente_pins[71].should be_nil
      @board.gote_pins[11].should be_nil
    end

    it 'successfully generates sente and gote pins' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::KI
      @board.board[85] = ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_kikis
      @board.load_ous
      @board.load_pins
      @board.sente_pins[85].should be_nil
      @board.gote_pins[15].should be_nil
      @board.gote_pins[25].should == 10
    end
  end

  describe '.execute and .cancel' do
    it 'move a piece and bring it back' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::KI
      @board.board[43] = ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      @movement = ShogiBot::Move.new(from_point: 43, put: false, reverse: true, sente: true, to_point: 33, role_value: ShogiBot::Piece::HI)
      board = @board.dup
      board.execute(@movement)
      board.board[33].should == ShogiBot::Piece::RY
      board.board[43].should == ShogiBot::Piece::NONE
      board.cancel(@movement)
      11.upto(99).each do |point|
        board.board[point].should == @board.board[point]
      end
    end

    it 'put a piece and bring it back' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::KI
      @board.board[95] = ShogiBot::Piece::OU
      @board.sente_hand[ShogiBot::Piece::HI] = 1
      @board.load_all
      @movement = ShogiBot::Move.new(from_point: nil, put: true, reverse: false, sente: true, to_point: 33, role_value: ShogiBot::Piece::HI)
      board = @board.dup
      board.execute(@movement)
      board.board[33].should == ShogiBot::Piece::HI
      board.cancel(@movement)
      11.upto(99).each do |point|
        board.board[point].should == @board.board[point]
      end
      board.board[33].should == ShogiBot::Piece::NONE
      @board.sente_hand[ShogiBot::Piece::HI].should == 1
    end

    it 'take a piece and bring it back' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::KI
      @board.board[43] = ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      @movement = ShogiBot::Move.new(from_point: 43, put: false, reverse: true, sente: true, to_point: 25, role_value: ShogiBot::Piece::HI, take_role_value: ShogiBot::Piece::KI)
      board = @board.dup
      board.execute(@movement)
      board.board[25].should == ShogiBot::Piece::RY
      board.board[43].should == ShogiBot::Piece::NONE
      board.sente_hand[ShogiBot::Piece::KI].should == 1
      board.cancel(@movement)
      11.upto(99).each do |point|
        board.board[point].should == @board.board[point]
      end
      board.sente_hand[ShogiBot::Piece::KI].should == 0
      board.board[25].should == - ShogiBot::Piece::KI
      board.board[43].should == ShogiBot::Piece::HI
    end
  end
end
