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
      proponent_piece = get_piece(movement.from_point)
      set_piece_value(0, movement.from_point)
    else
      if self.sente
        proponent_piece = get_piece_in_sente_hand(movement.role_value)
        minus_piece_in_sente_hand(movement.role_value)
      else
        proponent_piece = get_piece_in_gote_hand(movement.role_value)
        minus_piece_in_gote_hand(movement.role_value)
      end
    end
    # if an opponent piece is on the point where the proponent piece moves
    opponent_piece = get_piece(movement.to_point)
    if opponent_piece
      opponent_piece.normalize
      if self.sente
        plus_piece_in_sente_hand(opponent_piece.role)
      else
        plus_piece_in_gote_hand(opponent_piece.role)
      end
    end
    if movement.reverse?
      proponent_piece.reverse!
    end
    set_piece_value(proponent_piece.value, movement.to_point)
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
    piece_value = get_piece_value(point)
    if piece_value == 0
      nil
    else
      Piece.new(piece_value)
    end
  end

  def get_piece_in_gote_hand(role_value)
    if gote_hand[role_value] >= 1
      Piece.new(- role_value)
    else
      nil
    end
  end

  def get_piece_in_sente_hand(role_value)
    if sente_hand[role_value] >= 1
      Piece.new(role_value)
    else
      nil
    end
  end

  def get_piece_value(point)
    attr = "p_#{point[0]}#{point[1]}"
    read_attribute(attr)
  end

  def minus_piece_in_gote_hand(role_value)
    hand = self.gote_hand
    if hand[role_value] >= 1
      hand[role_value] -= 1
    else
      hand[role_value] = 0
    end
    self.gote_hand = hand
  end

  def minus_piece_in_sente_hand(role_value)
    hand = self.sente_hand
    if hand[role_value] >= 1
      hand[role_value] -= 1
    else
      hand[role_value] = 0
    end
    self.sente_hand = hand
  end

  def ou_in_gote_hand?
    self.gote_hand[Piece::OU] >= 1
  end

  def ou_in_sente_hand?
    self.sente_hand[Piece::OU] >= 1
  end

  def plus_piece_in_gote_hand(role_value)
    hand = self.gote_hand
    hand[role_value] += 1
    self.gote_hand = hand
  end

  def plus_piece_in_sente_hand(role_value)
    hand = self.sente_hand
    hand[role_value] += 1
    self.sente_hand = hand
  end

  def set_piece(piece, point)
    attr = "p_#{point[0]}#{point[1]}"
    write_attribute(attr, piece.to_i)
  end
  alias :set_piece_value :set_piece

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
    set_piece_value(piece_value, [x, y])
    set_piece_value(- piece_value, [10 - x, 10 - y])
    if double
      set_piece_value(piece_value, [10 - x, y])
      set_piece_value(- piece_value, [x, 10 - y])
    end
  end

  def piece_opposite_mirror(piece, point)
    piece_mirror(piece, point, true)
  end
end
