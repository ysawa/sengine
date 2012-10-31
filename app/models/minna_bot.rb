# -*- coding: utf-8 -*-

class MinnaBot < Bot
  @queue = :bot_serve

  attr_accessor :bot_sente
  attr_accessor :game
  attr_accessor :last_board

  def generate_valid_candidates
    candidates = []
    11.upto(99).each do |from_value|
      next if from_value % 10 == 0
      from_point = Point.new(from_value)
      piece = @last_board.get_piece(from_point)
      next unless piece && @bot_sente == piece.sente?
      if @bot_sente
        moves = Piece::SENTE_MOVES[piece.role]
      else
        moves = Piece::GOTE_MOVES[piece.role]
      end
      push_valid_piece_move_candidates(piece, from_point, candidates)
    end
    candidates
  end

  def generate_movement(attributes = {})
    attributes = attributes.reverse_merge(
      sente: @bot_sente,
      number: @last_board.number + 1
    )
    movement = Movement.new attributes
    if movement.role_value
      movement.write_attribute(:role, Piece::ROLE_STRINGS[movement.role_value])
    end
    movement
  end

  def process_next_movement(game)
    @game = find_game(game)
    @bot_sente = @game.sente_user_id == id
    @last_board = @game.boards.last
    if @last_board.sente? == @bot_sente
      raise Bot::InvalidConditions.new 'turn is invalid'
    end
    candidates = generate_valid_candidates
    new_movement = candidates.sample
    @game.make_board_from_movement!(new_movement)
  end

  def push_valid_piece_move_candidates(piece, from_point, candidates)
    from_value = from_point.x * 10 + from_point.y
    if @bot_sente
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
      to_piece = @last_board.get_piece(to_point)
      next if to_piece && to_piece.sente? == @bot_sente
      attributes = {
        from_point: from_point,
        to_point: to_point,
        move: true,
        put: false
      }
      candidates << generate_movement(attributes)
    end
    candidates
  end

  def score
    2000
  end

  def work?
    Shogiengine.system.resque_work?
  end
end
