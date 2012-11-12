# -*- coding: utf-8 -*-

module SBot
  class Piece
    class UnexpectedNormalize < StandardError; end
    class UnexpectedReverse < StandardError; end
    class InvalidAttributes < StandardError; end
    class NoneCannotBeTaken < InvalidAttributes; end
    include ActiveModel::AttributeMethods
    # <tt>Piece</tt> generate more understandable instances from role value.
    # Role value is only an integer and we cannot find what the value means.
    # Convert role value into a Piece instance, and get some convenient methods.

    # role values
    NONE = 0
    FU = 1; KY =  2; KE =  3; GI =  4; KI = 5; KA =  6; HI =  7; OU = 8;
    TO = 9; NY = 10; NK = 11; NG = 12;       ; UM = 14; RY = 15;
    ROLES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15]
    NORMAL_ROLES = [1, 2, 3, 4, 6, 7]
    REVERSED_ROLES = [9, 10, 11, 12, 14, 15]
    SPECIAL_ROLES = [5, 8]
    HAND_ROLES = [1, 2, 3, 4, 5, 6, 7, 8]

    SCORES = [nil, 10, 50, 55, 70, 80, 100, 120, 20000, 90, 80, 80, 80, nil, 150, 180]

    SENTE_MOVES = [
      nil,
      [-10], [], [-21, -19], [11, 9, -9, -10, -11], # FU, KY, KE, GI
      [10, 1, -1, -9, -10, -11], [], [], [-11, -10, -9, -1, 1, 9, 10, 11], # KI, KA, HI, OU
      [10, 1, -1, -9, -10, -11], [10, 1, -1, -9, -10, -11], # TO, NY
      [10, 1, -1, -9, -10, -11], [10, 1, -1, -9, -10, -11], # NK, NG
      nil, [-10, -1, 1, 10], [-11, -9, 9, 11] # nil, UM, RY
    ]
    GOTE_MOVES = [
      nil,
      [10], [], [21, 19], [11, 10, 9, -9, -11], # FU, KY, KE, GI
      [11, 10, 9, 1, -1, -10], [], [], [11, 10, 9, 1, -1, -9, -10, -11], # KI, KA, HI, OU
      [11, 10, 9, 1, -1, -10], [11, 10, 9, 1, -1, -10], # TO, NY
      [11, 10, 9, 1, -1, -10], [11, 10, 9, 1, -1, -10], # NK, NG
      nil, [10, 1, -1, -10], [11, 9, -9, -11], [], # nil, UM, RY
    ]
    SENTE_JUMPS = [
      nil,
      [], [-10], [], [], # FU, KY, KE, GI
      [], [-11, -9, 9, 11], [-10, -1, 1, 10], [], # KI, KA, HI, OU
      [], [], [], [], # TO, NY, KY, NG
      nil, [-11, -9, 9, 11], [-10, -1, 1, 10], # nil, UM, RY
    ]
    GOTE_JUMPS = [
      nil,
      [], [10], [], [], # FU, KY, KE, GI
      [], [-11, -9, 9, 11], [-10, -1, 1, 10], [], # KI, KA, HI, OU
      [], [], [], [], # TO, NY, KY, NG
      nil, [-11, -9, 9, 11], [-10, -1, 1, 10], # nil, UM, RY
    ]

    # role value with sente flag
    # if sente this value is positive, else the value is negative
    attr_reader :value
    # pure role value (not consists sente flag)
    attr_reader :role
    # sente flag
    attr_reader :sente

    alias :to_i :value

    def initialize(value)
      case value
      when NONE
        raise NoneCannotBeTaken.new(value)
      when Integer
        self.value = value
      else
        raise InvalidAttributes.new(value)
      end
    end

    def jumps
      if sente?
        SENTE_JUMPS[self.role]
      else
        GOTE_JUMPS[self.role]
      end
    end

    def moves
      if sente?
        SENTE_MOVES[self.role]
      else
        GOTE_MOVES[self.role]
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

    def role=(role)
      if sente?
        @value = role
      else
        @value = - role
      end
      @role = role
    end

    def score
      SCORES[@role]
    end

    def sente=(sente)
      if sente
        @value = self.role
      else
        @value = - self.role
      end
      @sente = sente
    end

    def sente?
      @sente
    end

    def value=(value)
      @sente = value > 0
      @role = value.abs
      @value = value
    end
  end
end
