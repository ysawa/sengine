# -*- coding: utf-8 -*-

class ScoreCalculator
  attr_accessor :winner_score, :loser_score
  attr_reader :winner_next_score, :loser_next_score, :score_change
  GRADE_SCORES = [
        0,  1000,  2000,  3000,  4000,  5000,  6000,  7000,  8000,  9000, 10000, 11000, # Beginner to 5 Kyu
    12000, 13000, 14000, 15000, 16000, 18000, 20000, 22000, 24000, 26000, 28000, 30000 # 6 Kyu to 8 Dan
  ]
  SCORE_CHANGES = [
    [-3630, 310], [-3380, 300], [-3130, 290], [-2880, 280], [-2630, 270], [-2380, 260],
    [-2130, 250], [-1880, 240], [-1630, 230], [-1380, 220], [-1130, 210],  [-880, 200],
     [-630, 190],  [-380, 180],  [-130, 170],   [120, 160],   [370, 150],   [620, 140],
      [870, 130],  [1120, 120],  [1370, 110],  [1620, 100],   [1870, 90],   [2120, 80],
      [2370, 70],   [2620, 60],   [2870, 50],   [3120, 40],   [3370, 30],   [3620, 20],
      [3990, 10]
  ]

  def calculate
    @score_difference = @winner_score - @loser_score
    if @score_difference.abs < 4000
      SCORE_CHANGES.each do |score_change|
        difference = score_change[0]
        @score_change = score_change[1]
        break if @score_difference <= difference
      end
    else
      @score_change = 0
    end
    @winner_next_score = @winner_score + @score_change
    @loser_next_score = @loser_score - @score_change
    if @loser_next_score < 0
      @loser_next_score = 0
    end
  end

  def initialize(winner_score = 0, loser_score = 0)
    @winner_score = winner_score
    @loser_score = loser_score
    @winner_next_score = winner_score
    @loser_next_score = loser_score
    @score_change = 0
  end

  class << self
    def grade_to_score(grade)
      GRADE_SCORES[grade]
    end

    def score_to_grade(score)
      now_grade = 0
      past_grade_score = 0
      GRADE_SCORES.each_with_index do |grade_score, grade|
        next if grade == 0
        average = (grade_score + past_grade_score) / 2
        break if average > score
        past_grade_score = grade_score
        now_grade = grade
      end
      now_grade
    end
  end
end
