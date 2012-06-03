# -*- coding: utf-8 -*-

class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  field :finished_at, type: Time
  field :number, type: Integer, default: 0
  field :playing, type: Boolean, default: true
  has_many :boards
  has_many :movements
  belongs_to :sente_user, class_name: 'User', inverse_of: :sente_games
  belongs_to :gote_user, class_name: 'User', inverse_of: :gote_games
  belongs_to :won_user, class_name: 'User', inverse_of: :won_games
  belongs_to :lost_user, class_name: 'User', inverse_of: :lost_games
  belongs_to :author, class_name: 'User', inverse_of: :created_games
  before_destroy :destroy_boards

  def make_board_from_movement(movement)
    number = self.boards.count
    board = self.boards.last.dup
    board.apply_movement(movement)
    board.number = number + 1
    self.boards << board
    self.movements << movement
    self.number = number
    self.save
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
