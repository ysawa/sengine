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

    def generate_kikis
      @sente_kikis = Kikis.new
      @gote_kikis = Kikis.new
      11.upto(99).each do |from_point|
        next if from_point % 10 == 0
        piece = get_piece(from_point)
        next unless piece
        piece_sente = piece.sente?
        piece.moves.each do |move|
          to_point = from_point + move
          next if to_point % 10 == 0 ||
              to_point <= 10 ||
              to_point >= 100
          if piece_sente
            @sente_kikis.append_move(to_point, - move)
          else
            @gote_kikis.append_move(to_point, - move)
          end
        end
        piece.jumps.each do |jump|
          to_point = from_point
          1.upto(8).each do |i|
            to_point += jump
            break if to_point % 10 == 0 ||
                to_point <= 10 ||
                to_point >= 100
            if piece_sente
              @sente_kikis.append_jump(to_point, - jump)
            else
              @gote_kikis.append_jump(to_point, - jump)
            end
            piece = get_piece(to_point)
            break if piece
          end
        end
      end
    end

    def get_piece(point)
      value = @board[point]
      if value != 0
        Piece.new(value)
      end
    end

    def initialize(board = nil, number = 0)
      @number = number
      @board = Array.new(SIZE)
      @sente_hand = [nil, 0, 0, 0, 0, 0, 0, 0, 0]
      @gote_hand = [nil, 0, 0, 0, 0, 0, 0, 0, 0]
    end
  end
end
