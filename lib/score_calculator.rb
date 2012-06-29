# -*- coding: utf-8 -*-

class ScoreCalculator
  attr_accessor :winner_score, :loser_score
  GRADE_SCORES = [
       0,  100,  200,  300,  400,  500,  600,  700,  800,  900, 1000, 1100, # Beginner to 5 Kyu
    1200, 1300, 1400, 1500, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000 # 6 Kyu to 8 Dan
  ]

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
