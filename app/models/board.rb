# -*- coding: utf-8 -*-

class Board
  class InvalidMovement < StandardError; end
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :sente, type: Boolean
  field :number, type: Integer
  belongs_to :game
  has_one :movement # movement from the past board to this board
  attr_protected :sente, :number, :game_id

  # Pieces on the board
  p_attr_names = []
  11.upto(99).each do |number|
    unless (number % 10) == 0
      attr_name = "p_#{number}"
      field attr_name, type: Integer, default: 0
      p_attr_names << attr_name
    end
  end
  attr_protected *p_attr_names

  # Pieces in hands
  field :gote_hand, type: Hand, default: [nil, 0, 0, 0, 0, 0, 0, 0, 0]
  field :sente_hand, type: Hand, default: [nil, 0, 0, 0, 0, 0, 0, 0, 0]
  attr_protected :gote_hand, :sente_hand
  before_destroy :destroy_movement

  def apply_movement(movement)
    raise InvalidMovement.new("movement is invalid: #{movement.inspect}") unless movement.valid?
    self.movement = movement
    self.sente = movement.sente
    raise InvalidMovement.new("invalid movement number: #{movement.inspect}") unless movement.number == self.number
    if movement.put?
      if self.sente
        proponent_piece = get_piece_in_sente_hand(movement.role)
        minus_piece_in_sente_hand(movement.role)
      else
        proponent_piece = get_piece_in_gote_hand(movement.role)
        minus_piece_in_gote_hand(movement.role)
      end
    else
      proponent_piece = get_piece(movement.from_point)
      set_piece_value(0, movement.from_point)
      raise InvalidMovement.new("invalid movement turn: #{movement.inspect}") unless proponent_piece.sente? == movement.sente?
    end
    unless proponent_piece
      raise InvalidMovement.new "no proponent piece: #{movement.inspect}"
    end
    # if an opponent piece is on the point where the proponent piece moves
    opponent_piece = get_piece(movement.to_point)
    if opponent_piece
      opponent_piece.normalize
      raise InvalidMovement.new("invalid movement taking piece: #{movement.inspect}") unless opponent_piece.sente? ^ movement.sente?
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
    self.sente = false
    self.number = 0
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

  def get_piece_in_gote_hand(role)
    if gote_hand[role] >= 1
      Piece.new(- role)
    else
      nil
    end
  end

  def get_piece_in_sente_hand(role)
    if sente_hand[role] >= 1
      Piece.new(role)
    else
      nil
    end
  end

  def get_piece_value(point)
    case point
    when Point, Array
      attr = "p_#{point[0]}#{point[1]}"
    when Integer
      attr = "p_#{point}"
    else
      raise
    end
    read_attribute(attr)
  end

  def minus_piece_in_gote_hand(role)
    hand = self.gote_hand
    if hand[role] >= 1
      hand[role] -= 1
    else
      raise InvalidMovement.new("invalid put: #{movement.inspect}")
    end
    self.gote_hand = hand
  end

  def minus_piece_in_sente_hand(role)
    hand = self.sente_hand
    if hand[role] >= 1
      hand[role] -= 1
    else
      raise InvalidMovement.new("invalid put: #{movement.inspect}")
    end
    self.sente_hand = hand
  end

  def ou_in_gote_hand?
    self.gote_hand[Piece::OU] >= 1
  end

  def ou_in_sente_hand?
    self.sente_hand[Piece::OU] >= 1
  end

  def plus_piece_in_gote_hand(role)
    hand = self.gote_hand
    hand[role] += 1
    self.gote_hand = hand
  end

  def plus_piece_in_sente_hand(role)
    hand = self.sente_hand
    hand[role] += 1
    self.sente_hand = hand
  end

  def set_piece(piece, point)
    attr = "p_#{point[0]}#{point[1]}"
    write_attribute(attr, piece.to_i)
  end
  alias :set_piece_value :set_piece

  def to_json
    attrs = attributes.dup
    board = []
    11.upto(99).each do |i|
      attr = "p_#{'%02d' % i}"
      piece = attrs.delete(attr)
      board << piece
    end
    attrs['board'] = board
    %w(sente gote).each do |user|
      hand = [nil]
      hand_name = "#{user}_hand"
      user_hand = attrs[hand_name]
      Hand::KEY_NAMES.each do |key|
        hand << user_hand[key]
      end
      attrs[hand_name] = hand
    end
    attrs.to_json
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
