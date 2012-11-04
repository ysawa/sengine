# -*- coding: utf-8 -*-

class MinnaBot < Bot
  @queue = :bot_serve

  attr_accessor :bot_sente
  attr_accessor :game
  attr_accessor :last_board

  def decode_movement(bot_movement)
    bot_attrs = bot_movement.attributes
    movement = Movement.new(bot_attrs)
    %w(from_point to_point).each do |attr_name|
      point = bot_attrs[attr_name]
      if point
        point_x = point % 10
        point_y = point / 10
        movement.write_attribute(attr_name, [point_x, point_y])
      else
        movement.write_attribute(attr_name, nil)
      end
    end
    movement
  end

  # convert Board into ShogiBot::Board
  def encode_board(board)
    bot_board = ShogiBot::Board.new(nil, board.number)
    1.upto(9).each do |x|
      1.upto(9).each do |y|
        piece_value = board.get_piece_value([x, y])
        bot_point = y * 10 + x
        bot_board.board[bot_point] = piece_value
      end
    end
    bot_board.sente_hand = board.sente_hand.to_a
    bot_board.gote_hand = board.gote_hand.to_a
    bot_board
  end

  def process_next_movement(game)
    @game = find_game(game)
    @bot_sente = @game.sente_user_id == id
    @last_board = @game.boards.last
    if @last_board.sente? == @bot_sente
      raise Bot::InvalidConditions.new 'turn is invalid'
    end
    estimator = ShogiBot::Estimator.new
    bot_board = encode_board(@last_board)
    candidates = estimator.generate_valid_candidates(@bot_sente, bot_board)
    if candidates.size == 0
      give_up!(@game)
    else
      new_bot_movement = candidates.sample
      new_movement = decode_movement(new_bot_movement)
      @game.make_board_from_movement!(new_movement)
    end
  end

  def score
    5000
  end

  def work?
    true
  end
end
