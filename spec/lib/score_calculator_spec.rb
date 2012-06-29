# -*- coding: utf-8 -*-

require 'spec_helper'
require 'score_calculator'

describe ScoreCalculator do
  before :each do
    @calculator = ScoreCalculator.new
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
