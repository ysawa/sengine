# -*- coding: utf-8 -*-

module ShogiBot
  class Kiki
    # kiki is represented with Array of Integer
    # and shows where the place can be attached from.
    #
    # Think about the view of sente.
    #
    #   8     -12
    #   9  -1 -11
    #  10   P -10
    #  11   1  -9
    #  12      -8

    #
    # The kiki of the place in front of sente's fu is
    #
    #  [1]

    # Kikis on the board
    attr_reader :move_kikis
    attr_reader :jump_kikis

    def append_jump(point, value)
      @jump_kikis[point] ||= []
      @jump_kikis[point] << value
    end

    def append_move(point, value)
      @move_kikis[point] ||= []
      @move_kikis[point] << value
    end

    def get_jump_kikis(point)
      @jump_kikis[point]
    end

    def get_move_kikis(point)
      @move_kikis[point]
    end

    def initialize
      @move_kikis = []
      @jump_kikis = []
      11.upto(99) do |point|
        next if point % 10 == 0
        @move_kikis[point] = []
        @jump_kikis[point] = []
      end
    end

    class << self
    end
  end
end
