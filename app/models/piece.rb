# -*- coding: utf-8 -*-

class Piece
  class UnexpectedNormalize < StandardError; end
  class UnexpectedReverse < StandardError; end
  class InvalidAttributes < StandardError; end
  # <tt>Piece</tt> generate more understandable instances from role value.
  # Role value is only an integer and we cannot find what the value means.
  # Convert role value into a Piece instance, and get some convenient methods.

  # role values
  FU = 1; KY =  2; KE =  3; GI =  4; KI = 5; KA =  6; HI =  7; OU = 8;
  TO = 9; NY = 10; NK = 11; NG = 12;       ; UM = 14; RY = 15;
  ROLES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15]
  NORMAL_ROLES = [1, 2, 3, 4, 6, 7]
  REVERSED_ROLES = [9, 10, 11, 12, 14, 15]
  SPECIAL_ROLES = [5, 8]
  HAND_ROLES = [1, 2, 3, 4, 5, 6, 7, 8]
  ROLE_STRINGS = %w(* fu ky ke gi ki ka hi ou to ny nk ng * um ry *)

  # role value with sente flag
  # if sente this value is positive, else the value is negative
  attr_accessor :value
  # pure role value (not consists sente flag)
  attr_accessor :role
  # sente flag
  attr_accessor :sente

  alias :to_i :value

  def initialize(value)
    case value
    when 0
      raise InvalidAttributes.new(value)
    when Integer
      self.value = value
    else
      raise InvalidAttributes.new(value)
    end
  end

  def normalize
    if reversed?
      @role -= 8
      reload_value
    end
  end

  def normalize!
    if reversed?
      normalize
    else
      raise UnexpectedNormalize
    end
  end

  def normalized?
    NORMAL_ROLES.include? @role
  end

  def gote?
    !sente?
  end

  def reload_value
    if sente?
      @value = @role
    else
      @value = - @role
    end
  end

  def reverse
    if normalized?
      @role += 8
      reload_value
    end
  end

  def reverse!
    if normalized?
      reverse
    else
      raise UnexpectedReverse
    end
  end

  def reversed?
    REVERSED_ROLES.include? @role
  end

  def sente?
    @sente
  end

  def stringify_role
    Piece.stringify_role(@role)
  end

  def value=(integer)
    @value = integer
    @sente = integer > 0
    @role = integer.abs
  end

  class << self
    def stringify_role(role)
      case role
      when String
        role
      else
        ROLE_STRINGS[role]
      end
    end
  end
end
