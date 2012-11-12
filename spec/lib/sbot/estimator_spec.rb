# -*- coding: utf-8 -*-

require 'spec_helper'
require 'sbot'

describe SBot::Estimator do
  before :each do
    @user = Fabricate :user
    @game = Fabricate :game
  end

  let :bot do
    MinnaBot.new
  end

  let :estimator do
    SBot::Estimator.new
  end

  describe '.oute?' do
    it 'successfully checks if player is in oute?' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::KI
      @board.board[85] = SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      estimator.oute?(true, @board).should be_false
      estimator.oute?(false, @board).should be_false
      @board.board[25] = SBot::Piece::NONE
      @board.load_all
      estimator.oute?(true, @board).should be_false
      estimator.oute?(false, @board).should be_true
    end
  end

  describe '.estimate' do
    it 'generate score differential as Integer' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[85] = SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      estimator.estimate(@board).should be_a Integer
      estimator.estimate(@board).should > 0
    end

    it 'generate score from hand' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[95] = SBot::Piece::OU
      @board.sente_hand[SBot::Piece::HI] = 1
      @board.load_all
      estimator.estimate(@board).should > 0
    end

    it 'generate score for gote' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[95] = SBot::Piece::OU
      @board.gote_hand[SBot::Piece::HI] = 1
      @board.load_all
      estimator.estimate(@board).should < 0
    end

    it 'generate score for kikis' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[14] = - SBot::Piece::HI
      @board.board[54] = SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      estimator.estimate(@board).should be_a Integer
      estimator.estimate(@board).should > 0
    end
  end

  describe '.generate_valid_candidates' do
    it 'successfully escape from oute' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.length.should == 4
      candidates.select { |candidate| candidate.role_value == SBot::Piece::OU && candidate.to_point == 85 }
          .size.should == 0
    end

    it 'successfully consider pins' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::HI
      @board.board[75] = SBot::Piece::KI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.length.should == 7
      candidates.select { |candidate| candidate.role_value == SBot::Piece::KI && candidate.to_point == 76 }
          .size.should == 0
      candidates.select { |candidate| candidate.role_value == SBot::Piece::KI && candidate.to_point == 65 }
          .size.should == 1
    end

    it 'successfully put fu' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[95] = SBot::Piece::OU
      @board.sente_hand[SBot::Piece::FU] = 1
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == SBot::Piece::FU && candidate.put? }
          .size.should == 81 - 9 - 1
      candidates.length.should == 81 - 9 - 1 + 5
    end

    it 'successfully put fu to be aigoma' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[25] = - SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.sente_hand[SBot::Piece::FU] = 1
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == SBot::Piece::FU && candidate.put? }
          .size.should == 6
      candidates.length.should == 6 + 4
    end

    it 'successfully reverse fu if necessary' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[24] = SBot::Piece::FU
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == SBot::Piece::FU && !candidate.reverse? }
          .size.should == 0
      candidates.size.should == 1 + 5
    end

    it 'successfully put fu but not to be nifu' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[82] = SBot::Piece::FU
      @board.board[95] = SBot::Piece::OU
      @board.sente_hand[SBot::Piece::FU] = 1
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == SBot::Piece::FU &&
          candidate.put? &&
          (candidate.to_point % 10 == 2)
      }
          .size.should == 0
      candidates.length.should == 81 - 9 - 7 - 1 + 5
    end

    it 'successfully ki cannot be reversed' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[35] = SBot::Piece::KI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == SBot::Piece::KI && candidate.reverse? }
          .size.should == 0
    end

    it 'successfully ki cannot be reversed' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[45] = SBot::Piece::KI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(true, @board)
      candidates.select { |candidate| candidate.role_value == SBot::Piece::KI && candidate.reverse? }
          .size.should == 0
    end

    it 'successfully ki cannot be reversed' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[75] = - SBot::Piece::KI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      candidates = estimator.generate_valid_candidates(false, @board)
      candidates.select { |candidate| candidate.role_value == SBot::Piece::KI && candidate.reverse? }
          .size.should == 0
    end
  end

  describe '.choose_best_candidate' do
    it 'works' do
      @board = SBot::Board.new
      @board.clear_board
      @board.board[15] = - SBot::Piece::OU
      @board.board[35] = - SBot::Piece::KI
      @board.board[85] = SBot::Piece::HI
      @board.board[95] = SBot::Piece::OU
      @board.load_all
      move = estimator.choose_best_candidate(true, @board)
      move.role_value.should == SBot::Piece::HI
      move.to_point.should == 35
      move.take_role_value.should == SBot::Piece::KI
    end
  end
end
