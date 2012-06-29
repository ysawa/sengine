# -*- coding: utf-8 -*-

require 'spec_helper'
require 'score_calculator'

describe ScoreCalculator do
  before :each do
    @calculator = ScoreCalculator.new
  end

  describe '.calculate' do
    context 'if difference between scores beyonds 400' do
      it 'scores do not change' do
        @calculator.winner_score = 2000
        @calculator.loser_score = 1000
        @calculator.calculate
        @calculator.score_change.should == 0
        @calculator.winner_next_score.should == 2000
        @calculator.loser_next_score.should == 1000

        @calculator.winner_score = 1000
        @calculator.loser_score = 2000
        @calculator.calculate
        @calculator.score_change.should == 0
        @calculator.winner_next_score.should == 1000
        @calculator.loser_next_score.should == 2000
      end
    end

    context 'if difference between scores are enough small' do
      it 'calculate difference between scores and score changes' do
        @calculator.winner_score = 1000
        @calculator.loser_score = 1000
        @calculator.calculate
        @calculator.score_change.should == 16
        @calculator.winner_next_score.should == 1016
        @calculator.loser_next_score.should == 984
      end

      it 'when difference is +150, the score change is 10' do
        @calculator.winner_score = 1150
        @calculator.loser_score = 1000
        @calculator.calculate
        @calculator.score_change.should == 10
        @calculator.winner_next_score.should == 1160
        @calculator.loser_next_score.should == 990
      end

      it 'when diffenrence is -338, the score change is 30' do
        @calculator.winner_score = 1000
        @calculator.loser_score = 1338
        @calculator.calculate
        @calculator.score_change.should == 30
        @calculator.winner_next_score.should == 1030
        @calculator.loser_next_score.should == 1308
      end

      it 'when diffenrence is -337, the score change is 29' do
        @calculator.winner_score = 1000
        @calculator.loser_score = 1337
        @calculator.calculate
        @calculator.score_change.should == 29
        @calculator.winner_next_score.should == 1029
        @calculator.loser_next_score.should == 1308
      end
    end
  end

  describe 'ScoreCalculator.grade_to_score' do
    it 'generates score from grade' do
      ScoreCalculator.grade_to_score(0).should == 0
      ScoreCalculator.grade_to_score(1).should == 100
      ScoreCalculator.grade_to_score(23).should == 3000
    end
  end

  describe 'ScoreCalculator.score_to_grade' do
    it 'generates grade from score' do
      ScoreCalculator.score_to_grade(0).should == 0
      ScoreCalculator.score_to_grade(49).should == 0
      ScoreCalculator.score_to_grade(50).should == 1
      ScoreCalculator.score_to_grade(100).should == 1
      ScoreCalculator.score_to_grade(3000).should == 23
      ScoreCalculator.score_to_grade(4000).should == 23
    end
  end
end
