# -*- coding: utf-8 -*-

class Piece
  class UnexpectedNormalize < StandardError; end
  class UnexpectedReverse < StandardError; end
  FU = 1; KY =  2; KE =  3; GI =  4; KI = 5; KA =  6; HI =  7; OU = 8;
  TO = 9; NY = 10; NK = 11; NG = 12;       ; UM = 14; RY = 15;
  ROLES = %w(fu ky ke gi ki ka hi ou to ny nk ng um ry)
  NORMAL_ROLES = %w(fu ky ke gi ki ka hi ou)
  REVERSED_ROLES = %w(to ny nk ng ki um ry ou)
  attr_accessor :sente, :role, :value
  alias :to_i :value

  def initialize(value)
    @value = value
    @sente = value > 0
    @role = value.abs
  end

  def normalize
    if reversed?
      @role = ROLES[REVERSED_ROLES.index(@role)]
    else
      raise UnexpectedNormalize
    end
  end

  def normalized?
    NORMAL_ROLES.include?(@role)
  end

  def gote?
    !sente?
  end

  def reverse
    if normalized?
      @role = REVERSED_ROLES[ROLES.index(@role)]
    else
      raise UnexpectedReverse
    end
  end

  def reversed?
    REVERSED_ROLES.include?(@role)
  end

  def sente?
    @sente
  end

  def stringify_role
    Piece.stringify_role(@role)
  end

  class << self
    def stringify_role(role)
      ROLES[role - 1]
    end
  end
end
