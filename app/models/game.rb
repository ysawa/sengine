# -*- coding: utf-8 -*-

class Game
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :boards
  has_many :movements
  belongs_to :sente_user, class_name: 'User'
  belongs_to :gote_user, class_name: 'User'
  before_destroy :destroy_boards

  def make_board_from_movement(movement)
    number = self.boards.count
    board = self.boards.last.dup
    board.apply_movement(movement)
    board.number = number + 1
    self.boards << board
    self.movements << movement
  end

private
  def destroy_boards
    self.boards.destroy_all
  end
end
