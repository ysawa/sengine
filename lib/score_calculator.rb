# -*- coding: utf-8 -*-

class ScoreCalculator
  attr_accessor :winner_score, :loser_score
  attr_reader :winner_next_score, :loser_next_score, :score_change
  GRADE_SCORES = [
       0,  100,  200,  300,  400,  500,  600,  700,  800,  900, 1000, 1100, # Beginner to 5 Kyu
    1200, 1300, 1400, 1500, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000 # 6 Kyu to 8 Dan
  ]
  SCORE_CHANGES = [
    [-363, 31], [-338, 30], [-313, 29], [-288, 28], [-263, 27], [-238, 26],
    [-213, 25], [-188, 24], [-163, 23], [-138, 22], [-113, 21],  [-88, 20],
     [-63, 19],  [-38, 18],  [-13, 17],   [12, 16],   [37, 15],   [62, 14],
      [87, 13],  [112, 12],  [137, 11],  [162, 10],   [187, 9],   [212, 8],
      [237, 7],   [262, 6],   [287, 5],   [312, 4],   [337, 3],   [362, 2],
      [399, 1]
  ]

  def calculate
    @score_difference = @winner_score - @loser_score
    if @score_difference.abs < 400
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
