# -*- coding: utf-8 -*-

module SBot
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
        if move.sente > 0
          @sente_hand[move.role] += 1
        else
          @gote_hand[move.role] += 1
        end
        @board[move.to_point] = Piece::NONE
      else
        to_piece = move.take_role
        if to_piece && to_piece != 0
          if to_piece >= 9
            to_piece -= 8
          end
          if move.sente > 0
            @board[move.to_point] = - move.take_role
            @sente_hand[to_piece] -= 1
          else
            @board[move.to_point] = move.take_role
            @gote_hand[to_piece] -= 1
          end
        else
          @board[move.to_point] = Piece::NONE
        end
        if move.sente > 0
          @board[move.from_point] = move.role
        else
          @board[move.from_point] = - move.role
        end
      end
      @number -= 1
      load_all
    end

    def clear_board
      SIZE.times do |point|
        if out_of_board?(point)
          @board[point] = Piece::WALL
        else
          @board[point] = Piece::NONE
        end
      end
    end

    def execute(move)
      if move.put?
        @board[move.to_point] = move.role
        if move.sente?
          @sente_hand[move.role] -= 1
        else
          @gote_hand[move.role] -= 1
        end
      else
        # take piece on to_point
        to_piece = @board[move.to_point].abs
        if to_piece && to_piece != 0
          if to_piece >= 9
            to_piece -= 8
          end
          if move.sente > 0
            @sente_hand[to_piece] += 1
          else
            @gote_hand[to_piece] += 1
          end
        end
        @board[move.from_point] = Piece::NONE
        if move.reverse?
          if move.sente > 0
            @board[move.to_point] = move.role + 8
          else
            @board[move.to_point] = - move.role - 8
          end
        else
          if move.sente > 0
            @board[move.to_point] = move.role
          else
            @board[move.to_point] = - move.role
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
      y_offset = 0
      10.times do |i|
        point = i
        @board[point] = Piece::WALL
        point = 101 + i
        @board[point] = Piece::WALL
        y_offset += 10
        point = y_offset
        @board[point] = Piece::WALL
      end
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
        piece = @board[from_point]
        next if piece == Piece::WALL || piece == Piece::NONE
        if piece > 0
          piece_sente = 1
          moves = Piece::SENTE_MOVES[piece]
          jumps = Piece::SENTE_JUMPS[piece]
        else
          piece_sente = -1
          moves = Piece::GOTE_MOVES[- piece]
          jumps = Piece::GOTE_JUMPS[- piece]
        end
        moves.each do |move|
          to_point = from_point + move
          next if out_of_board?(to_point)
          if piece_sente > 0
            @sente_kikis.append_move(to_point, - move)
          else
            @gote_kikis.append_move(to_point, - move)
          end
        end
        jumps.each do |jump|
          to_point = from_point
          1.upto(8).each do |i|
            to_point += jump
            break if out_of_board?(to_point)
            if piece_sente > 0
              @sente_kikis.append_jump(to_point, - jump)
            else
              @gote_kikis.append_jump(to_point, - jump)
            end
            piece = @board[to_point]
            break if piece != Piece::NONE
          end
        end
      end
    end

    def load_ous
      @sente_ou = @gote_ou = nil
      11.upto(99).each do |point|
        piece = @board[point]
        next if piece == Piece::WALL || piece == Piece::NONE
        if piece == Piece::OU
          @sente_ou = point
        elsif piece == - Piece::OU
          @gote_ou = point
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
          piece = @board[point]
          break if piece == Piece::WALL
          next if piece == Piece::NONE
          if piece > 0 && @gote_kikis.get_jump_kikis(point).include?(move)
            @sente_pins[point] = move
          end
          break
        end
      end
      Piece::GOTE_MOVES[Piece::OU].each do |move|
        point = @gote_ou
        1.upto(8).each do
          point += move
          piece = @board[point]
          break if piece == Piece::WALL
          next if piece == Piece::NONE
          if piece < 0 && @sente_kikis.get_jump_kikis(point).include?(move)
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
