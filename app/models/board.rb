# -*- coding: utf-8 -*-

class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sente, type: Boolean
  field :number, type: Integer
  belongs_to :game
  has_one :movement

  # Pieces on the board
  11.upto(99).each do |number|
    unless (number % 10) == 0
      field "p_#{number}", type: Integer, default: 0
    end
  end

  # Pieces in hands
  field :gote_hand, type: Hand, default: [nil, 0, 0, 0, 0, 0, 0, 0, 0]
  field :sente_hand, type: Hand, default: [nil, 0, 0, 0, 0, 0, 0, 0, 0]
  before_destroy :destroy_movement


  # TODO this method must have some exceptions
  def apply_movement(movement)
    self.movement = movement
    self.sente = movement.sente
    if movement.from_point
      proponent_piece = piece_on_point(movement.from_point)
    else
      if self.sente
        proponent_piece = piece_in_sente_hand(movement.role)
      else
        proponent_piece = piece_in_gote_hand(movement.role)
      end
    end
    # if an opponent piece is on the point where the proponent piece moves
    opponent_piece = piece_on_point(movement.to_point)
    if opponent_piece
      opponent_piece.in_hand = true
      opponent_piece.sente = movement.sente
      opponent_piece.point = nil
      opponent_piece.normalize if opponent_piece.reversed?
    end
    proponent_piece.in_hand = false
    if movement.reverse?
      proponent_piece.reverse
    end
    proponent_piece.point = movement.to_point
  end

  def hirate
    write_attributes({ sente: false, number: 0 })
    piece_opposite_mirror(Piece::KY, [1, 9])
    piece_opposite_mirror(Piece::KE, [2, 9])
    piece_opposite_mirror(Piece::GI, [3, 9])
    piece_opposite_mirror(Piece::KI, [4, 9])
    piece_mirror(Piece::OU, [5, 9])
    piece_mirror(Piece::KA, [8, 8])
    piece_mirror(Piece::HI, [2, 8])
    1.upto(9).each do |x|
      piece_mirror(Piece::FU, [x, 7])
    end
    true
  end

  def get_piece(point)
    attr = "p_#{point[0]}#{point[1]}"
    read_attribute(attr)
  end

  def gyoku_in_gote_hand?
    self.pieces.in_gote_hand('gyoku').present?
  end

  def gyoku_in_sente_hand?
    self.pieces.in_sente_hand('gyoku').present?
  end

  def piece_in_gote_hand(role = nil)
    self.pieces.in_gote_hand(role).first
  end

  def piece_in_sente_hand(role = nil)
    self.pieces.in_sente_hand(role).first
  end

  def piece_on_point(point)
    self.pieces.on_point(point).first
  end

  def set_piece(piece, point)
    attr = "p_#{point[0]}#{point[1]}"
    write_attribute(attr, piece.to_i)
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

  def piece_mirror(piece, point, double = false)
    x = point[0]
    y = point[1]
    piece_value = piece.to_i
    set_piece(piece, [x, y])
    set_piece(- piece, [10 - x, 10 - y])
    if double
      set_piece(piece, [10 - x, y])
      set_piece(- piece, [x, 10 - y])
    end
  end

  def piece_opposite_mirror(piece, point)
    piece_mirror(piece, point, true)
  end
end
