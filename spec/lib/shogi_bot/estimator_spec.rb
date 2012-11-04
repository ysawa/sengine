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
    before :each do
      pending
      @game.create_first_board
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
    end
    it 'successfully checks if player is in oute?' do
      estimator.game = @game
      last_board = @game.boards.last
      kikis = estimator.generate_kikis(last_board)
      estimator.oute?(true, last_board, kikis).should be_false
      estimator.oute?(false, last_board, kikis).should be_false
      last_board.p_57 = Piece::NONE
      last_board.p_52 = Piece::FU
      kikis = estimator.generate_kikis(last_board)
      estimator.oute?(true, last_board, kikis).should be_false
      estimator.oute?(false, last_board, kikis).should be_true
    end
  end

  describe '.generate_valid_candidates' do
    before :each do
      pending
      @game.create_first_board
      @game.sente_user = bot
      @game.gote_user = @game.author = @user
      @game.save
    end
    it 'successfully generates candidates of movements' do
      estimator.game = @game
      kikis = estimator.generate_kikis(@game.boards.last)
      candidates = estimator.generate_valid_candidates(true, @game.boards.last, kikis)
      candidates.should be_a Array
    end

    it 'successfully generates candidates of movements with putting movements' do
      estimator.game = @game
      last_board = @game.boards.last
      last_board.p_97 = Piece::NONE
      sente_hand = last_board.sente_hand
      sente_hand['fu'] = 1
      last_board.sente_hand = sente_hand
      last_board.save
      kikis = estimator.generate_kikis(last_board)
      candidates = estimator.generate_valid_candidates(true, @game.boards.last, kikis)
      candidates.should be_a Array
      candidates.last.put.should be_true
    end

    it 'successfully generates candidates to escape in oute' do
      estimator.game = @game
      last_board = @game.boards.last
      last_board.p_53 = Piece::NONE
      last_board.p_58 = - Piece::FU
      last_board.save
      kikis = estimator.generate_kikis(last_board)
      estimator.oute?(true, last_board, kikis).should be_true
      candidates = estimator.generate_valid_candidates(true, @game.boards.last, kikis)
      candidates.size.should == 6
    end
  end
end
