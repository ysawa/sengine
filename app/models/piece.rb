# -*- coding: utf-8 -*-

class Piece
  class UnexpectedNormalize < StandardError; end
  class UnexpectedReverse < StandardError; end
  include Mongoid::Document
  ROLES = %w(fu kyosha keima gin kin kaku hisha gyoku)
  REVERSED_ROLES = %w(tokin narikyo narikei narigin kin uma ryu gyoku)
  field :sente, type: Boolean
  field :in_hand, type: Boolean
  field :role, type: String
  field :point, type: Point
  embedded_in :board

  def normalize
    if reversed?
      self.role = ROLES[REVERSED_ROLES.index(self.role)]
    else
      raise UnexpectedNormalize
    end
  end

  def normalized?
    ROLES.include?(self.role)
  end

  def gote?
    !sente?
  end

  def on_board?
    !in_hand?
  end

  def reverse
    if normalized?
      self.role = REVERSED_ROLES[ROLES.index(self.role)]
    else
      raise UnexpectedReverse
    end
  end

  def reversed?
    REVERSED_ROLES.include?(self.role)
  end

  class << self
    def place(role, point, sente)
      new(role: role, point: point, sente: sente, in_hand: false)
    end
  end
end
