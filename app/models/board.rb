# -*- coding: utf-8 -*-

class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sente, type: Boolean
  field :number, type: Integer
  belongs_to :game
  has_one :movement
  embeds_many :pieces do
    def in_hand
      @target.select do |piece|
        piece.in_hand?
      end
    end

    def in_gote_hand
      @target.select do |piece|
        piece.in_hand? and piece.gote?
      end
    end

    def in_sente_hand
      @target.select do |piece|
        piece.in_hand? and piece.sente?
      end
    end

    def on_point(point)
      @target.select do |piece|
        point == piece.point
      end
    end
  end

  before_destroy :destroy_movement

  def apply_movement(movement)
    self.movement = movement
    self.sente = movement.sente
    if movement.from_point
      proponent_piece = piece_on_point(movement.from_point)
    end
    opponent_piece = piece_on_point(movement.to_point)
    if opponent_piece
      opponent_piece.in_hand = true
      opponent_piece.sente = movement.sente
      opponent_piece.point = nil
    end
    proponent_piece.point = movement.to_point
  end

  def hirate
    write_attributes({ sente: false, number: 0 })
    piece_mirror('gyoku', [5, 9])
    piece_opposite_mirror('kin', [4, 9])
    piece_opposite_mirror('gin', [3, 9])
    piece_opposite_mirror('keima', [2, 9])
    piece_opposite_mirror('kyosha', [1, 9])
    piece_mirror('kaku', [8, 8])
    piece_mirror('hisha', [2, 8])
    1.upto(9).each do |x|
      piece_mirror('fu', [x, 7])
    end
    true
  end

  def piece_on_point(point)
    self.pieces.on_point(point).first
  end

  class << self
    def hirate
      board = new
      board.hirate
      board
    end
  end

private
  def destroy_movement
    self.movement.destroy if self.movement
  end

  def piece_mirror(role, point, double = false)
    x = point[0]
    y = point[1]
    self.pieces << Piece.place(role, [x, y], true)
    self.pieces << Piece.place(role, [(10 - x).abs, (10 - y).abs], false)
    if double
      self.pieces << Piece.place(role, [(10 - x).abs, y], true)
      self.pieces << Piece.place(role, [x, (10 - y).abs], false)
    end
  end

  def piece_opposite_mirror(role, point)
    piece_mirror(role, point, true)
  end
end
