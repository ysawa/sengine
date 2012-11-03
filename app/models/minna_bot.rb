# -*- coding: utf-8 -*-

class MinnaBot < Bot
  @queue = :bot_serve

  attr_accessor :bot_sente
  attr_accessor :game
  attr_accessor :last_board

  def generate_valid_candidates(player_sente, board)
    candidates = []
    11.upto(99).each do |from_value|
      next if from_value % 10 == 0
      from_point = Point.new(from_value)
      piece = board.get_piece(from_point)
      next unless piece && player_sente == piece.sente?
      if player_sente
        moves = Piece::SENTE_MOVES[piece.role]
      else
        moves = Piece::GOTE_MOVES[piece.role]
      end
      candidates += generate_valid_piece_move_candidates(player_sente, board, piece, from_point)
      candidates += generate_valid_piece_jump_candidates(player_sente, board, piece, from_point)
    end
    candidates += generate_valid_piece_put_candidates(player_sente, board)
    candidates
  end

  def process_next_movement(game)
    @game = find_game(game)
    @bot_sente = @game.sente_user_id == id
    @last_board = @game.boards.last
    if @last_board.sente? == @bot_sente
      raise Bot::InvalidConditions.new 'turn is invalid'
    end
    candidates = generate_valid_candidates(@bot_sente, @last_board)
    new_movement = candidates.sample
    @game.make_board_from_movement!(new_movement)
  end

  def score
    2000
  end

  def work?
    Shogiengine.system.resque_work?
  end

private

  def generate_valid_piece_jump_candidates(player_sente, board, piece, from_point)
    candidates = []
    from_value = from_point.x * 10 + from_point.y
    if player_sente
      jumps = Piece::SENTE_JUMPS[piece.role]
    else
      jumps = Piece::GOTE_JUMPS[piece.role]
    end
    jumps.each do |jump|
      to_value = from_value
      8.times do |i|
        to_value += jump
        break if to_value <= 10 ||
            to_value >= 100 ||
            (to_value % 10 == 0)
        to_point = Point.new(to_value)
        to_piece = board.get_piece(to_point)
        break if to_piece && to_piece.sente? == player_sente
        attributes = {
          from_point: from_point,
          number: board.number + 1,
          put: false,
          reverse: false,
          role_value: piece.role,
          sente: player_sente,
          to_point: to_point
        }
        if piece.reversed?
          candidates << Movement.new(attributes)
        else
          if (player_sente && to_point.y <= 2) ||
              (!player_sente && to_point.y >= 8)
            attributes[:reverse] = true
            candidates << Movement.new(attributes)
          elsif (player_sente && from_point.y <= 3) ||
              (!player_sente && from_point.y >= 7) ||
              (player_sente && to_point.y <= 3) ||
              (!player_sente && to_point.y >= 7)
            candidates << Movement.new(attributes)
            attributes[:reverse] = true
            candidates << Movement.new(attributes)
          else
            candidates << Movement.new(attributes)
          end
        end
        break if to_piece && to_piece.sente? != player_sente
      end
    end
    candidates
  end

  def generate_valid_piece_move_candidates(player_sente, board, piece, from_point)
    candidates = []
    from_value = from_point.x * 10 + from_point.y
    if player_sente
      moves = Piece::SENTE_MOVES[piece.role]
    else
      moves = Piece::GOTE_MOVES[piece.role]
    end
    moves.each do |move|
      to_value = from_value + move
      next if to_value <= 10 ||
          to_value >= 100 ||
          (to_value % 10 == 0)
      to_point = Point.new(to_value)
      to_piece = board.get_piece(to_point)
      next if to_piece && to_piece.sente? == player_sente
      attributes = {
        from_point: from_point,
        number: board.number + 1,
        put: false,
        reverse: false,
        role_value: piece.role,
        sente: player_sente,
        to_point: to_point
      }
      if piece.reversed? ||
          piece.role == Piece::KI ||
          piece.role == Piece::OU
        candidates << Movement.new(attributes)
      else
        if piece.role == Piece::KE &&
            ((player_sente && to_point.y <= 2) ||
                (!player_sente && to_point.y >= 8))
          attributes[:reverse] = true
          candidates << Movement.new(attributes)
          elsif (player_sente && from_point.y <= 3) ||
              (!player_sente && from_point.y >= 7) ||
              (player_sente && to_point.y <= 3) ||
              (!player_sente && to_point.y >= 7)
          candidates << Movement.new(attributes)
          attributes[:reverse] = true
          candidates << Movement.new(attributes)
        else
          candidates << Movement.new(attributes)
        end
      end
    end
    candidates
  end

  def generate_valid_piece_put_candidates(player_sente, board)
    candidates = []
    if player_sente
      hand = board.sente_hand.to_a
    else
      hand = board.gote_hand.to_a
    end
    attributes = {
      number: board.number + 1,
      put: true,
      reverse: false,
      sente: player_sente
    }
    hand.each_with_index do |number, key|
      next if !number || number == 0
      case key
      when Piece::FU, Piece::KY
        if player_sente
          y_start = 2
          y_end = 9
        else
          y_start = 1
          y_end = 8
        end
      when Piece::KE
        if player_sente
          y_start = 3
          y_end = 9
        else
          y_start = 1
          y_end = 7
        end
      else
        y_start = 1
        y_end = 9
      end
      attributes[:role_value] = key
      y_start.upto(y_end).each do |y|
        1.upto(9).each do |x|
          to_point = Point.new(x, y)
          piece = board.get_piece(to_point)
          next if piece
          attributes[:to_point] = to_point
          candidates << Movement.new(attributes)
        end
      end
    end
    candidates
  end
end
