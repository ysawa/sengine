# -*- coding: utf-8 -*-

require 'score_calculator'
class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  field :finished_at, type: Time
  field :number, type: Integer, default: 0
  field :playing, type: Boolean, default: true
  field :theme, type: String, default: 'default'

  THEMES = %w(default)
  has_many :boards
  has_many :movements
  belongs_to :sente_user, class_name: 'User', inverse_of: :sente_games
  belongs_to :gote_user, class_name: 'User', inverse_of: :gote_games
  belongs_to :won_user, class_name: 'User', inverse_of: :won_games
  belongs_to :lost_user, class_name: 'User', inverse_of: :lost_games
  belongs_to :author, class_name: 'User', inverse_of: :created_games
  before_destroy :destroy_boards

  def apply_score_changes!
    calculator = ScoreCalculator.new
    calculator.winner_score = self.won_user.score
    calculator.loser_score = self.lost_user.score
    calculator.calculate
    self.won_user.write_score_with_grade(calculator.winner_next_score)
    self.lost_user.write_score_with_grade(calculator.loser_next_score)
    if self.won_user.valid? && self.lost_user.valid?
      self.won_user.save
      self.lost_user.save
      true
    else
      false
    end
  end

  def check_if_playing
    if self.playing?
      board = self.boards.last
      if board.ou_in_sente_hand?
        # sente win
        self.won_user = self.sente_user
        self.lost_user = self.gote_user
        false
      elsif board.ou_in_gote_hand?
        # gote win
        self.won_user = self.gote_user
        self.lost_user = self.sente_user
        false
      else
        true
      end
    else
      false
    end
  end

  def check_and_save_if_playing
    if self.playing?
      self.playing = check_if_playing
      unless self.playing
        # game finished first
        apply_score_changes!
      end
      save
    else
      false
    end
  end

  def make_board_from_movement(movement)
    number = self.boards.count
    board = self.boards.last.dup
    board.apply_movement(movement)
    board.number = number
    self.boards << board
    self.movements << movement
    self.number = number
    board
  end

  def make_board_from_movement!(movement)
    board = make_board_from_movement(movement)
    board.save && self.save
  end

  def users
    result = []
    result << self.sente_user if self.sente_user
    result << self.gote_user if self.gote_user
    result
  end

  def of_user?(user)
    if user
      self.sente_user_id == user.id || self.gote_user_id == user.id
    else
      false
    end
  end

  class << self
    def of_user(user)
      criteria.any_of({ sente_user_id: user.id }, { gote_user_id: user.id })
    end
  end

private
  def destroy_boards
    self.boards.destroy_all
  end
end
