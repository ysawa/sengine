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

    attr_accessor :sente_ou
    attr_accessor :gote_ou

    def cancel(move)
      if move.put?
        if move.sente?
          @sente_hand[move.role_value] += 1
        else
          @gote_hand[move.role_value] += 1
        end
        @board[move.to_point] = Piece::NONE
      else
        to_piece = move.take_role_value
        if to_piece && to_piece != 0
          if to_piece >= 9
            to_piece -= 8
          end
          if move.sente?
            @board[move.to_point] = - move.take_role_value
            @sente_hand[to_piece] -= 1
          else
            @board[move.to_point] = move.take_role_value
            @gote_hand[to_piece] -= 1
          end
        else
          @board[move.to_point] = Piece::NONE
        end
        if move.sente?
          @board[move.from_point] = move.role_value
        else
          @board[move.from_point] = - move.role_value
        end
      end
      @number -= 1
      load_all
    end

    def clear_board
      SIZE.times do |point|
        if out_of_board?(point)
          @board[point] = nil
        else
          @board[point] = 0
        end
      end
    end

    def execute(move)
      if move.put?
        @board[move.to_point] = move.role_value
        if move.sente?
          @sente_hand[move.role_value] -= 1
        else
          @gote_hand[move.role_value] -= 1
        end
      else
        # take piece on to_point
        to_piece = @board[move.to_point].abs
        if to_piece && to_piece != 0
          if to_piece >= 9
            to_piece -= 8
          end
          if move.sente?
            @sente_hand[to_piece] += 1
          else
            @gote_hand[to_piece] += 1
          end
        end
        @board[move.from_point] = Piece::NONE
        if move.reverse?
          if move.sente?
            @board[move.to_point] = move.role_value + 8
          else
            @board[move.to_point] = - move.role_value - 8
          end
        else
          if move.sente?
            @board[move.to_point] = move.role_value
          else
            @board[move.to_point] = - move.role_value
          end
        end
      end
      @number += 1
      load_all
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

    def load_all
      load_ous
      if @sente_ou && @gote_ou
        load_kikis
        load_pins
      end
    end

    def load_kikis
      @sente_kikis = Kikis.new
      @gote_kikis = Kikis.new
      11.upto(99).each do |from_point|
        next if from_point % 10 == 0
        piece = get_piece(from_point)
        next unless piece
        piece_sente = piece.sente?
        piece.moves.each do |move|
          to_point = from_point + move
          next if out_of_board?(to_point)
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
            break if out_of_board?(to_point)
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

    def load_ous
      @sente_ou = @gote_ou = nil
      11.upto(99).each do |point|
        next if point % 10 == 0
        piece = get_piece(point)
        next unless piece
        if piece.role == Piece::OU
          if piece.sente?
            @sente_ou = point
          else
            @gote_ou = point
          end
        end
        break if @sente_ou && @gote_ou
      end
      nil
    end

    def load_pins
      @sente_pins = Array.new(SIZE)
      @gote_pins = Array.new(SIZE)
      Piece::SENTE_MOVES[Piece::OU].each do |move|
        point = @sente_ou
        1.upto(8).each do
          point += move
          break if out_of_board?(point)
          piece = get_piece(point)
          next unless piece
          if piece.sente? && @gote_kikis.get_jump_kikis(point).include?(move)
            @sente_pins[point] = move
          end
          break
        end
      end
      Piece::GOTE_MOVES[Piece::OU].each do |move|
        point = @gote_ou
        1.upto(8).each do
          point += move
          break if out_of_board?(point)
          piece = get_piece(point)
          next unless piece
          if piece.gote? && @sente_kikis.get_jump_kikis(point).include?(move)
            @gote_pins[point] = move
          end
          break
        end
      end
      nil
    end

    def out_of_board?(point)
      self.class.out_of_board?(point)
    end

    def to_str
      lines = []
      lines << 'G: ' + @gote_hand.join(' ')
      1.upto(9).each do |y|
        pieces = []
        9.downto(1).each do |x|
          point = y * 10 + x
          value = @board[point]
          pieces << ("%3d" % value)
          pieces.join(' ')
        end
        lines << pieces.join
      end
      lines << 'S: ' + @sente_hand.join(' ')
      lines.join("\n")
    end

    class << self
      def out_of_board?(point)
        point % 10 == 0 || point <= 10 || point >= 100
      end
    end
  end
end
