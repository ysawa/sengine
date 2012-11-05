# -*- coding: utf-8 -*-

require 'spec_helper'
require 'shogi_bot'

describe ShogiBot::Estimator do
  before :each do
    @user = Fabricate :user
    @game = Fabricate :game
  end

  let :bot do
    MinnaBot.new
  end

  let :estimator do
    ShogiBot::Estimator.new
  end

  describe '.oute?' do
    it 'successfully checks if player is in oute?' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::KI
      @board.board[85] = ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      estimator.oute?(true, @board).should be_false
      estimator.oute?(false, @board).should be_false
      @board.board[25] = ShogiBot::Piece::NONE
      @board.load_all
      estimator.oute?(true, @board).should be_false
      estimator.oute?(false, @board).should be_true
    end
  end

  describe '.generate_valid_candidates' do
    it 'successfully escape from oute' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.length.should == 4
    end

    it 'successfully put fu' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[95] = ShogiBot::Piece::OU
      @board.sente_hand[ShogiBot::Piece::FU] = 1
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::FU && candidate.put? }
          .size.should == 81 - 9 - 1
      candidates.length.should == 81 - 9 - 1 + 5
    end

    it 'successfully reverse fu if necessary' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[24] = ShogiBot::Piece::FU
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::FU && !candidate.reverse? }
          .size.should == 0
      candidates.size.should == 1 + 5
    end
  end
end
