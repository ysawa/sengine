# -*- coding: utf-8 -*-

require 'spec_helper'
require 'sbot'

describe SBot::Board do
  before :each do
    @bot = MinnaBot.new
  end

  describe '.initialize' do
    it 'generate board with board data and number' do
      board = SBot::Board.new([], 1)
      board.number.should == 1
    end
  end

  describe '.load_kikis' do
    before :each do
      @board = @bot.encode_board(Board.hirate)
    end
    it 'successfully generates sente and gote kikis' do
      @board.load_kikis
      @board.sente_kikis.should be_a SBot::Kikis
      @board.sente_kikis.get_move_kikis(61).should == [10] # FU
      @board.sente_kikis.get_jump_kikis(61).should == [] # NONE
      @board.sente_kikis.get_jump_kikis(71).should == [10] # KY
      @board.sente_kikis.get_jump_kikis(81).should == [1, 10] # HI, KY
      @board.gote_kikis.should be_a SBot::Kikis
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
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::KI
      @board.board[85] = SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
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
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::KI
      @board.board[43] = SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      @movement = SBot::Move.new
      @movement.attributes = { from_point: 43, put: false, reverse: true, sente: true, to_point: 33, role: SBot::Piece::HI }
      board = @board.dup
      board.execute(@movement)
      board.board[33].should == SBot::Piece::RY
      board.board[43].should == SBot::Piece::NONE
      board.cancel(@movement)
      board.board[33].should == SBot::Piece::NONE
      board.board[43].should == SBot::Piece::HI
    end

    it 'put a piece and bring it back' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::KI
      @board.board[95] = SBot::Piece::OU
      @board.sente_hand[SBot::Piece::HI] = 1
      @board.load_all
      @movement = SBot::Move.new
      @movement.attributes = { from_point: nil, put: true, reverse: false, sente: true, to_point: 33, role: SBot::Piece::HI }
      board = @board.dup
      board.execute(@movement)
      board.board[33].should == SBot::Piece::HI
      board.cancel(@movement)
      board.board[33].should == SBot::Piece::NONE
      @board.sente_hand[SBot::Piece::HI].should == 1
    end

    it 'take a piece and bring it back' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::KI
      @board.board[43] = SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      @movement = SBot::Move.new
      @movement.attributes = { from_point: 43, put: false, reverse: true, sente: true, to_point: 25, role: SBot::Piece::HI, take_role: SBot::Piece::KI }
      board = @board.dup
      board.execute(@movement)
      board.board[25].should == SBot::Piece::RY
      board.board[43].should == SBot::Piece::NONE
      board.sente_hand[SBot::Piece::KI].should == 1
      board.cancel(@movement)
      board.sente_hand[SBot::Piece::KI].should == 0
      board.board[25].should == - SBot::Piece::KI
      board.board[43].should == SBot::Piece::HI
    end
  end
end
