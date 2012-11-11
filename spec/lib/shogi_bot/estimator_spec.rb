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

  describe '.estimate' do
    it 'generate score differential as Integer' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[85] = ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      estimator.estimate(@board).should be_a Integer
      estimator.estimate(@board).should > 0
    end

    it 'generate score from hand' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[95] = ShogiBot::Piece::OU
      @board.sente_hand[ShogiBot::Piece::HI] = 1
      @board.load_all
      estimator.estimate(@board).should > 0
    end

    it 'generate score for gote' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[95] = ShogiBot::Piece::OU
      @board.gote_hand[ShogiBot::Piece::HI] = 1
      @board.load_all
      estimator.estimate(@board).should < 0
    end

    it 'generate score for kikis' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[14] = - ShogiBot::Piece::HI
      @board.board[54] = ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      estimator.estimate(@board).should be_a Integer
      estimator.estimate(@board).should > 0
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
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::OU && candidate.to_point == 85 }
          .size.should == 0
    end

    it 'successfully consider pins' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::HI
      @board.board[75] = ShogiBot::Piece::KI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.length.should == 7
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::KI && candidate.to_point == 76 }
          .size.should == 0
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::KI && candidate.to_point == 65 }
          .size.should == 1
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

    it 'successfully put fu to be aigoma' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[25] = - ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.sente_hand[ShogiBot::Piece::FU] = 1
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::FU && candidate.put? }
          .size.should == 6
      candidates.length.should == 6 + 4
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

    it 'successfully put fu but not to be nifu' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[82] = ShogiBot::Piece::FU
      @board.board[95] = ShogiBot::Piece::OU
      @board.sente_hand[ShogiBot::Piece::FU] = 1
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::FU &&
          candidate.put? &&
          (candidate.to_point % 10 == 2)
      }
          .size.should == 0
      candidates.length.should == 81 - 9 - 7 - 1 + 5
    end

    it 'successfully ki cannot be reversed' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[35] = ShogiBot::Piece::KI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::KI && candidate.reverse? }
          .size.should == 0
    end

    it 'successfully ki cannot be reversed' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[45] = ShogiBot::Piece::KI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::KI && candidate.reverse? }
          .size.should == 0
    end

    it 'successfully ki cannot be reversed' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[75] = - ShogiBot::Piece::KI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(false, @board)
      candidates.select { |candidate| candidate.role_value == ShogiBot::Piece::KI && candidate.reverse? }
          .size.should == 0
    end
  end

  describe '.choose_best_candidate' do
    it 'works' do
      @board = ShogiBot::Board.new
      @board.clear_board
      @board.board[15] = - ShogiBot::Piece::OU
      @board.board[35] = - ShogiBot::Piece::KI
      @board.board[85] = ShogiBot::Piece::HI
      @board.board[95] = ShogiBot::Piece::OU
      @board.load_all
      move = estimator.choose_best_candidate(true, @board)
      move.role_value.should == ShogiBot::Piece::HI
      move.to_point.should == 35
      move.take_role_value.should == ShogiBot::Piece::KI
    end
  end
end
