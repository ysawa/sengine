# -*- coding: utf-8 -*-

module SBot
  class Kikis
    # kiki is represented with Array of Integer
    # and shows where the place can be attached from.
    #
    # Think about the view of sente.
    #
    #
    #  -19     -21
    #  -9 -10 -11
    #   1   P  -1
    #  11  10   9
    #  21      19

    #
    # The kiki of the place in front of sente's fu is
    #
    #  [10]

    # Kikis on the board
    attr_reader :move_kikis
    attr_reader :jump_kikis

    def append_jump(point, value)
      @jump_kikis[point] << value
    end

    def append_move(point, value)
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

    def set_jump_kikis(point, kikis)
      @jump_kikis[point] = kikis
    end

    def set_move_kikis(point, kikis)
      @move_kikis[point] = kikis
    end

    def remove_jump(point, value)
      @jump_kikis[point].delete value
    end

    def remove_move(point, value)
      @move_kikis[point].delete value
    end
  end
end
