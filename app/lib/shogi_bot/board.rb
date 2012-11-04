# -*- coding: utf-8 -*-

module ShogiBot
  class Board
    SIZE = 111
    # board sized with 111 pieces
    attr_accessor :board
    attr_accessor :number

    # hands of sente and gote
    attr_accessor :sente_hand
    attr_accessor :gote_hand

    # kikis of sente and gote
    attr_accessor :sente_kikis
    attr_accessor :gote_kikis

    # pins of sente and gote
    attr_accessor :sente_pins
    attr_accessor :gote_pins

    def generate_kikis(board)
      @sente_kikis = Array.new(SIZE)
      @gote_kikis = Array.new(SIZE)
      11.upto(99).each do |from_point|
        next if from_point % 10 == 0
        piece = board.get_piece(from_point)
        next unless piece
        piece_sente = piece.sente?
        piece.moves.each do |move|
          to_value = from_value + move
          next if to_value % 10 == 0 ||
              to_value <= 10 ||
              to_value >= 100
          if piece_sente
            sente_kikis.append_move(to_value, - move)
          else
            gote_kikis.append_move(to_value, - move)
          end
        end
        piece.jumps.each do |jump|
          to_value = from_value
          1.upto(8).each do |i|
            to_value += jump
            next if to_value % 10 == 0 ||
                to_value <= 10 ||
                to_value >= 100
            if piece_sente
              sente_kikis.append_jump(to_value, - jump)
            else
              gote_kikis.append_jump(to_value, - jump)
            end
            to_point = Point.new(to_value)
            piece = board.get_piece(to_point)
            break if piece
          end
        end
      end
      [sente_kikis, gote_kikis]
    end

    def get_piece(point)
      Piece.new(@board[point])
    end

    def initialize(board = nil, number = 0)
      @number = number
      @board = Array.new(SIZE)
      @sente_hand = [nil, 0, 0, 0, 0, 0, 0, 0, 0]
      @gote_hand = [nil, 0, 0, 0, 0, 0, 0, 0, 0]
    end
  end
end
