# -*- coding: utf-8 -*-

require 'spec_helper'
require 'score_calculator'

describe ScoreCalculator do
  before :each do
    @calculator = ScoreCalculator.new
  end

  describe '.calculate' do
    context 'if difference between scores beyonds 4000' do
      it 'scores do not change' do
        @calculator.winner_score = 20000
        @calculator.loser_score = 10000
        @calculator.calculate
        @calculator.score_change.should == 0
        @calculator.winner_next_score.should == 20000
        @calculator.loser_next_score.should == 10000

        @calculator.winner_score = 10000
        @calculator.loser_score = 20000
        @calculator.calculate
        @calculator.score_change.should == 0
        @calculator.winner_next_score.should == 10000
        @calculator.loser_next_score.should == 20000
      end
    end

    context 'if difference between scores are enough small' do
      it 'calculate difference between scores and score changes' do
        @calculator.winner_score = 10000
        @calculator.loser_score = 10000
        @calculator.calculate
        @calculator.score_change.should == 160
        @calculator.winner_next_score.should == 10160
        @calculator.loser_next_score.should == 9840
      end

      it 'when difference is +1500, the score change is 100' do
        @calculator.winner_score = 11500
        @calculator.loser_score = 10000
        @calculator.calculate
        @calculator.score_change.should == 100
        @calculator.winner_next_score.should == 11600
        @calculator.loser_next_score.should == 9900
      end

      it 'when diffenrence is -3380, the score change is 300' do
        @calculator.winner_score = 10000
        @calculator.loser_score = 13380
        @calculator.calculate
        @calculator.score_change.should == 300
        @calculator.winner_next_score.should == 10300
        @calculator.loser_next_score.should == 13080
      end

      it 'when diffenrence is -3370, the score change is 290' do
        @calculator.winner_score = 10000
        @calculator.loser_score = 13370
        @calculator.calculate
        @calculator.score_change.should == 290
        @calculator.winner_next_score.should == 10290
        @calculator.loser_next_score.should == 13080
      end

      it 'score should not be below 0' do
        @calculator.winner_score = 0
        @calculator.loser_score = 0
        @calculator.calculate
        @calculator.score_change.should == 160
        @calculator.winner_next_score.should == 160
        @calculator.loser_next_score.should == 0
      end
    end
  end

  describe 'ScoreCalculator.grade_to_score' do
    it 'generates score from grade' do
      ScoreCalculator.grade_to_score(0).should == 0
      ScoreCalculator.grade_to_score(1).should == 1000
      ScoreCalculator.grade_to_score(23).should == 30000
    end
  end

  describe 'ScoreCalculator.score_to_grade' do
    it 'generates grade from score' do
      ScoreCalculator.score_to_grade(0).should == 0
      ScoreCalculator.score_to_grade(490).should == 0
      ScoreCalculator.score_to_grade(500).should == 1
      ScoreCalculator.score_to_grade(1000).should == 1
      ScoreCalculator.score_to_grade(30000).should == 23
      ScoreCalculator.score_to_grade(40000).should == 23
    end
  end
end
